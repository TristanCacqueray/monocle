# Monocle.
# Copyright (C) 2019-2021 Monocle authors
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import os
import socket
import time

from typing import Optional, Tuple

from flask import Flask
from flask import abort
from flask import jsonify
from flask import make_response
from flask import request
from flask import session
from flask_cors import CORS
from flask_caching import Cache

from monocle import utils
from monocle.db.db import CHANGE_PREFIX
from monocle.db.db import ELmonocleDB
from monocle.db.db import InvalidIndexError
from monocle.task_data import TaskCrawler
from monocle.webapi import config_service, search_service, task_data_service
from monocle import config
from monocle import env


CACHE_TIMEOUT = 300  # 5 mn cache
INPUT_TASK_DATA_LIMIT = 500

cache = Cache(config={"CACHE_TYPE": "simple"})
app = Flask(__name__)
cache.init_app(app)

app.secret_key = os.urandom(16)
CORS(
    app,
    resources={r"/api/*": {"origins": os.getenv("ALLOW_ORIGIN", "*")}},
    supports_credentials=True,
)


def returnAPIError(desc: str, code: int, details: Optional[str] = None):
    abort(
        make_response(
            jsonify({"statusCode": code, "message": desc, "details": details}), code
        )
    )


@app.route("/api/0/health", methods=["GET"])
def health():
    data = {
        "hostname": socket.gethostname(),
        "status": "success",
        "timestamp": time.time(),
    }
    return jsonify(data)


def get_index(req):
    if "index" not in req.args or not req.args.get("index"):
        returnAPIError("No index provided", 404)
    return req.args["index"]


@app.route("/api/0/query/<name>", methods=["GET"])
def query(name):
    index = get_index(request)
    if not config.is_public_index(env.indexes_acl, index):
        user = session.get("username") or request.headers.get("Remote-User")
        if user:
            if user not in config.get_authorized_users(env.indexes_acl, index):
                returnAPIError("Unauthorized to access index %s" % index, 403)
        else:
            returnAPIError("Unauthorized to access index %s" % index, 403)
    repository_fullname = request.args.get("repository")
    try:
        ret = do_query(index, repository_fullname, request.args, name)
    except Exception:
        app.logger.exception(
            "Unable to process query %s (params: %s)"
            % (name, list(request.args.items()))
        )
        returnAPIError(
            (
                "The API server was unable to process the query."
                " Please retry after or modify the filter parameters."
            ),
            500,
        )
    return ret


def create_db_connection(index: Optional[str]) -> ELmonocleDB:
    return ELmonocleDB(
        elastic_conn=os.getenv("ELASTIC_CONN", "localhost:9200"),
        index=index,
        prefix=CHANGE_PREFIX,
        create=False,
        user=os.getenv("ELASTIC_USER", None),
        password=os.getenv("ELASTIC_PASSWORD", None),
        use_ssl=os.getenv("ELASTIC_USE_SSL", None),
        verify_certs=os.getenv("ELASTIC_INSECURE", None),
        ssl_show_warn=os.getenv("ELASTIC_SSL_SHOW_WARN", None),
    )


@cache.memoize(timeout=CACHE_TIMEOUT)
def do_query(index, repository_fullname, args, name):
    params = utils.set_params(args)
    params["_project_defs"] = env.project_defs.get(index)
    db = create_db_connection(index)
    try:
        result = db.run_named_query(name, repository_fullname, params)
    except InvalidIndexError:
        returnAPIError("Invalid index: %s" % request.args.get("index"), 404)
    return jsonify(result)


@app.route("/api/0/indices", methods=["GET"])
def indices():
    db = create_db_connection(None)
    _indices = db.get_indices()
    indices = []
    for indice in _indices:
        if config.is_public_index(env.indexes_acl, indice):
            indices.append(indice)
        else:
            user = session.get("username")
            if user:
                if user in config.get_authorized_users(env.indexes_acl, indice):
                    indices.append(indice)
    return jsonify(indices)


def task_data_endpoint_check_input_env(
    req, check_auth: bool, check_content_type: bool
) -> Tuple[str, TaskCrawler]:
    if "index" not in req.args or not req.args.get("index"):
        returnAPIError("No index provided", 404)
    index = req.args["index"]
    if index not in env.indexes_task_crawlers:
        return returnAPIError("No index with this name", 404)
    if "name" not in req.args or not req.args.get("name"):
        return returnAPIError("No crawler name provided", 404)
    name = req.args["name"]
    match_crawler_config = [
        c for c in env.indexes_task_crawlers[index] if c.name == name
    ]
    if not match_crawler_config:
        return returnAPIError("No crawler with this name", 404)
    crawler_config = match_crawler_config[0]
    apikey = None
    if check_auth:
        if "apikey" not in req.args and not req.args.get("apikey"):
            return returnAPIError("No crawler apikey provided", 404)
        apikey = req.args["apikey"]
        if apikey != crawler_config.api_key:
            return returnAPIError("Not authorized", 403)
    if check_content_type:
        if not req.is_json:
            return returnAPIError("Missing content-type application/json", 400)
    return index, crawler_config


@app.route("/api/0/task_data", methods=["GET"])
def task_data():
    if request.method == "GET":
        index, crawler_config = task_data_endpoint_check_input_env(
            request, check_auth=False, check_content_type=False
        )
        db = create_db_connection(index)
        metadata = db.get_task_crawler_metadata(crawler_config.name)
        if "details" in request.args and request.args.get("details") == "true":
            return jsonify(metadata)
        if not metadata.get("last_commit_at"):
            commit_date = crawler_config.updated_since.strftime("%Y-%m-%dT%H:%M:%S")
        else:
            commit_date = metadata["last_commit_at"]
        return jsonify(commit_date + "Z")


config_service(app)
search_service(app)
task_data_service(app)


def main():
    app.run(host="0.0.0.0", port=9876)


if __name__ == "__main__":
    main()
