// Monocle.
// Copyright (C) 2019-2020 Monocle authors

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.

// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import axios from 'axios'
import moment from 'moment'

// The api server is defined by:
// - window.API_URL value set by container runtime
// - REACT_APP_API_URL set by development environment
// - otherwise we assume the api is served by the proxy, on the same url as the static files.
const server =
  window.API_URL !== '__API_URL__'
    ? window.API_URL
    : process.env.REACT_APP_API_URL || ''
const baseurl = server + '/api/0'

console.log('BaseURL=' + baseurl)

function getQueryResults(queryParams) {
  const params = { ...queryParams }
  const url = baseurl + '/query/' + params.name

  params.ec_same_date = true
  delete params.name
  delete params.graph_type

  if (!params.gte) {
    params.gte = moment().subtract(3, 'months').format('YYYY-MM-DD')
  }

  if (params.changeIds) {
    params.change_ids = params.changeIds
    delete params.changeIds
  }

  if (params.excludeAuthors) {
    params.exclude_authors = params.excludeAuthors
    delete params.excludeAuthors
  }

  if (params.selfMerged) {
    params.self_merged = params.selfMerged
    delete params.selfMerged
  }

  if (params.branch) {
    params.target_branch = params.branch
    delete params.branch
  }

  if (params.excludeApprovals) {
    params.exclude_approvals = params.excludeApprovals
    delete params.excludeApprovals
  }

  return axios.get(url, {
    params: params,
    withCredentials: true
  })
}

function getAuth(authCB, anonCB) {
  // We use fetch to detect redirection
  fetch(server + '/api/2/a/whoami', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: '{}',
    redirect: 'manual'
  })
    .then((res) => {
      if (res.type === 'opaqueredirect') {
        // The session is not authenticated
        anonCB()
      } else if (res.ok) {
        return res.json()
      } else {
        console.error('whoami get failed', res)
      }
    })
    .then((data) => {
      if (data) {
        authCB(data)
      }
    })
    .catch((_) => console.error('whoami get threw'))
}

function logout() {
  return axios.get(server + '/api/2/auth/logout')
}

function getProjects(request) {
  return axios.post(baseurl + '/get_projects', request)
}

function getIndices() {
  const url = baseurl + '/indices'
  return axios.get(url, {
    withCredentials: true
  })
}

export { logout, getAuth, getQueryResults, getIndices, baseurl, getProjects, server }
