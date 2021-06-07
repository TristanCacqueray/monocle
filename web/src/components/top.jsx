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
import Table from 'react-bootstrap/Table'
import PropTypes from 'prop-types'
import Link from './LegacyLink.bs.js'

import ConnectionDiagram from './connection_diagram'

import { addUrlField } from './common'

class TopEventsTable extends React.Component {
  rowStyleFormat(average, value) {
    if (value >= average) {
      return { color: 'green' }
    }
  }

  render() {
    return (
      <Row>
        <Col>
          <Card>
            <Card.Header>
              <Card.Title>{this.props.title}</Card.Title>
            </Card.Header>
            <Card.Body>
              <Table striped responsive bordered hover size="sm">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>ID</th>
                    <th>count</th>
                  </tr>
                </thead>
                <tbody>
                  {this.props.data.items.map((x, index) => (
                    <tr key={index}>
                      <td
                        style={this.rowStyleFormat(
                          this.props.data.count_avg,
                          x.doc_count
                        )}
                      >
                        {index + 1}
                      </td>
                      <td>
                        <Link to={addUrlField('authors', x.key)}>{x.key}</Link>
                      </td>
                      <td>{x.doc_count}</td>
                    </tr>
                  ))}
                </tbody>
              </Table>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    )
  }
}

TopEventsTable.propTypes = {
  title: PropTypes.string.isRequired,
  data: PropTypes.shape({
    items: PropTypes.array,
    count_avg: PropTypes.number
  })
}

const CMostActiveAuthorsStats = (data) => (
  <Row>
    <Col>
      <Card>
        <Card.Header>
          <Card.Title>Most active authors stats</Card.Title>
        </Card.Header>
        <Card.Body>
          <Row>
            <Col md>
              <TopEventsTable
                data={data.data.ChangeCreatedEvent}
                title="By Created Changes"
              />
            </Col>
            <Col md>
              <TopEventsTable
                data={data.data.ChangeMergedEvent}
                title="By Merged Changes"
              />
            </Col>
          </Row>
          <Row>
            <Col>
              <p></p>
            </Col>
          </Row>
          <Row>
            <Col md>
              <TopEventsTable
                data={data.data.ChangeReviewedEvent}
                title="By Reviewed Changes"
              />
            </Col>
            <Col md>
              <TopEventsTable
                data={data.data.ChangeCommentedEvent}
                title="By Commented Changes"
              />
            </Col>
          </Row>
        </Card.Body>
      </Card>
    </Col>
  </Row>
)

const CMostReviewedAuthorsStats = (data) => (
  <Row>
    <Col>
      <Card>
        <Card.Header>
          <Card.Title>Most reviewed authors stats</Card.Title>
        </Card.Header>
        <Card.Body>
          <Row>
            <Col md>
              <TopEventsTable data={data.data.reviewed} title="Reviews" />
            </Col>
            <Col md>
              <TopEventsTable data={data.data.commented} title="Comments" />
            </Col>
          </Row>
        </Card.Body>
      </Card>
    </Col>
  </Row>
)

const CNewContributorsStats = (data) => (
  <Row>
    <Col>
      <Card>
        <Card.Header>
          <Card.Title>New contributors stats</Card.Title>
        </Card.Header>
        <Card.Body>
          <Row>
            <Col>
              <TopEventsTable data={data.data} title="Active Authors" />
            </Col>
          </Row>
        </Card.Body>
      </Card>
    </Col>
  </Row>
)

class TopStrengthsTable extends React.Component {
  render() {
    return (
      <Row>
        <Col>
          <Card>
            <Card.Header>
              <Card.Title>{this.props.title}</Card.Title>
            </Card.Header>
            <Card.Body>
              <Row>
                <Col>
                  <ConnectionDiagram data={this.props.data} />
                </Col>
              </Row>
              <Row>
                <Col>
                  <Table striped responsive bordered hover size="sm">
                    <thead>
                      <tr>
                        <th>#</th>
                        <th>Peers</th>
                        <th>Strength</th>
                      </tr>
                    </thead>
                    <tbody>
                      {this.props.data.slice(0, 15).map((x, index) => (
                        <tr key={index}>
                          <td>{index + 1}</td>
                          <td>
                            <Link
                              to={addUrlField(
                                'authors',
                                x[0][0] + ',' + x[0][1]
                              )}
                            >
                              {x[0][0]} and {x[0][1]}
                            </Link>
                          </td>
                          <td>{x[1]}</td>
                        </tr>
                      ))}
                    </tbody>
                  </Table>
                </Col>
              </Row>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    )
  }
}

TopStrengthsTable.propTypes = {
  title: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired
}

const CAuthorsPeersStats = (data) => (
  <TopStrengthsTable data={data.data} title="Peers strength" />
)

export {
  CNewContributorsStats,
  CMostActiveAuthorsStats,
  CMostReviewedAuthorsStats,
  CAuthorsPeersStats
}
