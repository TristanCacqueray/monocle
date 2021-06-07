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

import React from 'react'

import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Card from 'react-bootstrap/Card'
import Alert from 'react-bootstrap/Alert'
import Badge from 'react-bootstrap/Badge'
import Spinner from 'react-bootstrap/Spinner'
import PropTypes from 'prop-types'
import Link from './LegacyLink.bs.js'

import { RelativeDate } from './FiltersForm.bs.js'

function getWindowDimensions() {
  const { innerWidth: width, innerHeight: height } = window
  return {
    width,
    height
  }
}

function hasSmallWidth() {
  const { width } = getWindowDimensions()

  return width <= 500
}

function changeUrl(index, x, name = null) {
  if (!name) {
    name = x.change_id
  }
  return (
    <Link to={`/${index}/change/${x.change_id}${window.location.search}`}>
      {name}
    </Link>
  )
}

function addUrlField(field, value) {
  const url = new URL(window.location.href)

  url.searchParams.set(field, value)

  return url.pathname + url.search
}

function indexUrl(index, dest) {
  const url = new URL(window.location.href)

  url.pathname = `/${index}${dest}`
  return url.search ? url.pathname + url.search : url.pathname
}

function addS(count, s = 's') {
  if (count > 1) {
    return s
  } else {
    return ''
  }
}

function chooseApprovalBadgeStyle(app, idx = 0) {
  if (app === null) {
    return ''
  }
  if (
    app === 'REVIEW_REQUIRED' ||
    app === 'CHANGES_REQUESTED' ||
    app === 'APPROVED'
  ) {
    let approvalCat = 'success'
    if (app === 'REVIEW_REQUIRED') {
      approvalCat = 'info'
    }
    if (app === 'CHANGES_REQUESTED') {
      approvalCat = 'danger'
    }
    return (
      <Badge variant={approvalCat} key={idx}>
        {app}
      </Badge>
    )
  } else {
    const regex = '.*-.$'
    const patt = new RegExp(regex)
    let approvalCat = 'success'
    if (patt.test(app)) {
      approvalCat = 'danger'
    }
    if (app.includes('+0')) {
      approvalCat = 'info'
    }
    return (
      <Badge variant={approvalCat} key={idx}>
        {app}
      </Badge>
    )
  }
}

class MergeableStatusBadge extends React.Component {
  render() {
    const mergeable = this.props.mergeable.toLowerCase()
    switch (mergeable) {
      case 'mergeable':
        return <Badge variant="success">{mergeable}</Badge>
      case 'conflicting':
        return <Badge variant="warning">{mergeable}</Badge>
      case 'unknown':
        return <Badge variant="secondary">{mergeable}</Badge>
      default:
        return null
    }
  }
}

MergeableStatusBadge.propTypes = {
  mergeable: PropTypes.string.isRequired
}

class ChangeStatus extends React.Component {
  render() {
    if (this.props.data.state === 'OPEN' && this.props.data.draft) {
      return <Badge variant="dark">Draft</Badge>
    }
    switch (this.props.data.state) {
      case 'OPEN':
        return (
          <span>
            <Badge variant="success">Open</Badge>{' '}
            <MergeableStatusBadge mergeable={this.props.data.mergeable} />
          </span>
        )
      case 'MERGED':
        return <Badge variant="primary">Merged</Badge>
      case 'CLOSED':
        return <Badge variant="danger">Abandoned</Badge>
      default:
        return null
    }
  }
}

ChangeStatus.propTypes = {
  data: PropTypes.object
}

class SmallSizeWarning extends React.Component {
  render() {
    const { width } = getWindowDimensions()
    return (
      <React.Fragment>
        {width < 1024 ? (
          <Row>
            <Col>
              <Alert variant="warning" className="text-center">
                To get the best experience please use a device with a larger
                screen or rotate your device.
              </Alert>
            </Col>
          </Row>
        ) : (
          ''
        )}
      </React.Fragment>
    )
  }
}

const getFinalChangeState = (params) => {
  const state = params.get('state')
  let ret = state
  switch (state) {
    case 'SELF-MERGED':
      ret = 'MERGED'
      break
    default:
  }
  return ret
}

const mkQueryParams = (
  name,
  graphType,
  changeIds,
  forceAllAuthors,
  paramsStr,
  index,
  start,
  pageSize
) => {
  const params = new URLSearchParams(paramsStr)
  let queryParams = {}
  // if we have a changeIds, don't pass other non mandatory filters
  let gte = params.get('gte')
  let lte = params.get('lte')
  if (params.get('relativedate')) {
    gte = RelativeDate.strToDateString(params.get('relativedate'))
    lte = undefined
  }
  if (changeIds) {
    queryParams = {
      index: index,
      name: name,
      graph_type: graphType,
      repository: params.get('repository') || '.*',
      branch: params.get('branch'),
      gte: gte,
      changeIds: changeIds
    }
  } else {
    queryParams = {
      index: index,
      name: name,
      repository: params.get('repository') || '.*',
      branch: params.get('branch'),
      files: params.get('files'),
      gte: gte,
      lte: lte,
      excludeAuthors: params.get('exclude_authors'),
      task_priority: params.get('task_priority'),
      task_severity: params.get('task_severity'),
      task_type: params.get('task_type'),
      task_score: params.get('task_score'),
      project: params.get('project'),
      authors: forceAllAuthors ? null : params.get('authors'),
      graph_type: graphType,
      from: start * pageSize,
      size: pageSize
    }
    if (
      ['last_changes', 'repos_top', 'authors_top', 'approvals_top'].includes(
        name
      )
    ) {
      // Merge both associative arrays
      queryParams = {
        ...queryParams,
        ...{
          approvals: params.get('approvals'),
          excludeApprovals: params.get('exclude_approvals'),
          state: getFinalChangeState(params),
          selfMerged: params.get('state') === 'SELF-MERGED'
        }
      }
    }
  }
  return queryParams
}

export {
  mkQueryParams,
  changeUrl,
  addUrlField,
  indexUrl,
  addS,
  chooseApprovalBadgeStyle,
  getWindowDimensions,
  SmallSizeWarning,
  hasSmallWidth,
  ChangeStatus
}
