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
import ReactPaginate from 'react-paginate'
import PropTypes from 'prop-types'
import { ArrowUpRightSquare } from 'react-bootstrap-icons'
import Change from './Change.bs.js'
import Link from './LegacyLink.bs.js'

import moment from 'moment'

import {
  changeUrl,
  addUrlField,
  chooseApprovalBadgeStyle,
  ChangeStatus
} from './common'

import DurationComplexityGraph from './duration_complexity_graph'

const TaskData = Change.TaskData.make

class ChangesTable extends React.Component {
  render() {
    let paginationElement

    if (this.props.pageChangeCallback && this.props.pageCount > 1) {
      paginationElement = (
        <ReactPaginate
          forcePage={this.props.selectedPage}
          pageCount={this.props.pageCount}
          pageRangeDisplayed={5}
          marginPagesDisplayed={4}
          onPageChange={(data) =>
            this.props.pageChangeCallback(this.props.pageChangeTarget, data)
          }
          breakClassName={'page-item'}
          breakLinkClassName={'page-link'}
          containerClassName={'pagination'}
          pageClassName={'page-item'}
          pageLinkClassName={'page-link'}
          previousClassName={'page-item'}
          previousLinkClassName={'page-link'}
          nextClassName={'page-item'}
          nextLinkClassName={'page-link'}
          activeClassName={'active'}
        />
      )
    }
    const ChangeRowStyle = {
      paddingTop: '5px',
      paddingBottom: '5px',
      backgroundColor: '#f7f7f7',
      backgroundClip: 'content-box'
    }
    return (
      <Row>
        <Col>
          <Card>
            <Card.Header>
              <Card.Title>{this.props.title}</Card.Title>
            </Card.Header>
            <Card.Body>
              {this.props.graph !== '' ? (
                <React.Fragment>{this.props.graph}</React.Fragment>
              ) : null}
              {paginationElement}
              {this.props.data.items.map((change, index) => (
                <Row key={index} style={ChangeRowStyle}>
                  <Col>
                    <Row>
                      <Col md={9}>
                        <ChangeStatus data={change} /> {' - '}
                        <a
                          href={change.url}
                          target="_blank"
                          rel="noopener noreferrer"
                        >
                          <ArrowUpRightSquare />
                        </a>
                        {' - '}
                        <Link
                          to={addUrlField(
                            'repository',
                            change.repository_fullname
                          )}
                        >
                          {change.repository_fullname}
                        </Link>
                        {' - '}
                        {changeUrl(this.props.index, change, change.title)}
                      </Col>
                      <Col md={3}>Complexity: {change.complexity}</Col>
                    </Row>
                    <Row>
                      <Col md={9}>
                        Created {moment(change.created_at).fromNow()} by{' '}
                        <Link
                          className="span"
                          to={addUrlField('authors', change.author.muid)}
                        >
                          {change.author.muid}
                        </Link>
                        {' - '}
                        Updated {moment(change.updated_at).fromNow()}
                      </Col>
                      {change.state === 'MERGED' ||
                      change.state === 'CLOSED' ? (
                        <Col>
                          Duration:{' '}
                          {moment
                            .duration(change.duration, 'seconds')
                            .humanize()}
                        </Col>
                      ) : null}
                    </Row>
                    {change.approval.length > 0 ? (
                      <Row>
                        <Col>
                          Review approvals:{' '}
                          {change.approval.map((app, idx) => {
                            return (
                              <span key={idx}>
                                {chooseApprovalBadgeStyle(app, idx)}{' '}
                              </span>
                            )
                          })}
                        </Col>
                      </Row>
                    ) : (
                      ''
                    )}
                    {change.tasks_data !== undefined &&
                      change.tasks_data.map((td, idx) => (
                        <Row key={idx}>
                          <Col>
                            <TaskData td={td} />
                          </Col>
                        </Row>
                      ))}
                  </Col>
                </Row>
              ))}
            </Card.Body>
          </Card>
        </Col>
      </Row>
    )
  }
}

ChangesTable.propTypes = {
  title: PropTypes.oneOfType([PropTypes.string, PropTypes.element]).isRequired,
  data: PropTypes.shape({
    items: PropTypes.array
  }),
  pageCount: PropTypes.number,
  selectedPage: PropTypes.number,
  pageChangeCallback: PropTypes.func,
  pageChangeTarget: PropTypes.object,
  graph: PropTypes.element,
  index: PropTypes.string.isRequired
}

const CLastChangesNG = (data) => {
  let graph = <div></div>
  if (false && data.showComplexityGraph) {
    graph = (
      <DurationComplexityGraph
        history={this.props.history}
        data={data}
        timeFunc={this.extractTime}
        index={this.props.index}
      />
    )
  }
  return (
    <React.Fragment>
      <Row>
        <Col>
          <ChangesTable
            index={data.index}
            graph={graph}
            data={data.data}
            title={data.data.total + ' Changes'}
          />
        </Col>
      </Row>
    </React.Fragment>
  )
}

export { CLastChangesNG }
