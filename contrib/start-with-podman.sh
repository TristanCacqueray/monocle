#!/bin/bash

# Monocle.
# Copyright (C) 2019-2020 Monocle authors
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


####### USAGE #######


# This script is an helper for the developer to ease building a development
# environment using podman instead of docker.
#
# Build container images using the "build" parameter
# Create container using the "create" parameter
# Start container using the "start" parameter
# -> firefox http://localhost:8080
#
# crawler and api container use a bind the monocle python module, so
# you can hack the crawler and api code and simply restart the containers with
# podman restart monocle_api monocle_crawler
#
# To hack the WEB UI (after a complete run with "start") run
# the script with the "start-web-dev" parameter.
# -> firefox http://localhost:3000

set -x

if [ "$1" == "build" ]; then
    podman build -t monocle_web -f Dockerfile-web web
    podman build -t monocle_api -f Dockerfile-api .
    podman build -t monocle_backend -f Dockerfile .
fi

if [ "$1" == "create" ]; then

    [ -n "WITH_KIBANA" ] && {
        KIBANA_PORT="-p 5601:5601"
    }

    podman pod create -p 9200:9200 -p 9876:9876 -p 8080:8080 $KIBANA_PORT -n monocle

    podman create --name=elastic \
               --pod monocle \
               -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
               -e discovery.type="single-node" \
               --ulimit nofile=65535:65535 \
               -v ./data:/usr/share/elasticsearch/data:Z \
               docker.elastic.co/elasticsearch/elasticsearch:7.10.1

    [ -n "WITH_KIBANA" ] && {
        podman create --name=kibana \
                   --pod monocle \
                   --add-host elastic:127.0.0.1 \
                   -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
                   -e ELASTICSEARCH_HOSTS="http://elastic:9200" \
                   docker.elastic.co/kibana/kibana:7.10.1
    }

    podman create --name=api \
               --pod monocle \
               -e CONFIG=/etc/monocle/config.yaml \
               -e ELASTIC_CONN=elastic:9200 \
               --add-host elastic:127.0.0.1 \
               -v $PWD/etc:/etc/monocle:z \
               -v $PWD/monocle:/code/monocle:z \
               -it \
               monocle_backend uwsgi --http :9876 --manage-script-name --mount /app=monocle.webapp:app

    podman create --name=api-ng \
               --pod monocle \
               -e CONFIG=/etc/monocle/config.yaml \
               -e ELASTIC_CONN=elastic:9200 \
               --add-host elastic:127.0.0.1 \
               -v $PWD/etc:/etc/monocle:z \
               -it monocle_api monocle-api --port 9898

    podman create --name=crawler \
               --pod monocle \
               --add-host elastic:127.0.0.1 \
               -v $PWD/etc:/etc/monocle:z \
               -v $PWD/dump:/var/lib/crawler:Z \
               -it \
               -v $PWD/monocle:/code/monocle:z \
               monocle_backend monocle --elastic-conn elastic:9200 crawler --config /etc/monocle/config.yaml

    podman create --name=web \
               --pod monocle \
               --add-host api:127.0.0.1 \
               --add-host api-ng:127.0.0.1 \
               -e REACT_APP_TITLE="Monocle Podman deployment" \
               monocle_web
fi

if [ "$1" == "rm" ]; then
    podman pod rm monocle
fi

if [ "$1" == "start" ]; then
    podman pod start monocle
    # Re-attempt to start monocle_crawler - sometime race condition failure
    podman start crawler
fi

if [ "$1" == "stop" ]; then
    podman pod stop monocle
fi

if [ "$1" == "start-web-dev" ]; then
    podman stop web
    cd web && npm install && REACT_APP_TITLE="Monocle live dev deployment" npm start
fi
