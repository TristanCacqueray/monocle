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
import ListGroup from 'react-bootstrap/ListGroup'
import PropTypes from 'prop-types'
import Link from './LegacyLink.bs.js'

import { Line } from 'react-chartjs-2'

import moment from 'moment'

import { hasSmallWidth } from './common'

class ChangeLifeCycleEventsHisto extends React.Component {
  prepareDataSet(histos) {
    const createdColor = '135,255,149'
    const updatedColor = '153,102,102'
    const mergedColor = '169,135,255'
    const abandonedColor = '92,92,92'
    const eventNameMapping = {
      ChangeCreatedEvent: {
        label: 'Created',
        pointBorderColor: 'rgba(' + createdColor + ',1)',
        pointBackgroundColor: '#fff',
        backgroundColor: 'rgba(' + createdColor + ',0.4)',
        borderColor: 'rgba(' + createdColor + ',1)'
      },
      ChangeMergedEvent: {
        label: 'Merged',
        pointBorderColor: 'rgba(' + mergedColor + ',1)',
        pointBackgroundColor: '#fff',
        backgroundColor: 'rgba(' + mergedColor + ',0.4)',
        borderColor: 'rgba(' + mergedColor + ',1)'
      },
      ChangeAbandonedEvent: {
        label: 'Abandoned',
        pointBorderColor: 'rgba(' + abandonedColor + ',1)',
        pointBackgroundColor: '#fff',
        backgroundColor: 'rgba(' + abandonedColor + ',0.4)',
        borderColor: 'rgba(' + abandonedColor + ',1)'
      }
    }

    const metaData = Object.entries(eventNameMapping)
    const data = {
      labels: histos.ChangeCreatedEvent[0].map((x) => x.key_as_string),
      datasets: []
    }
    metaData.forEach((desc) => {
      data.datasets.push({
        label: desc[1].label,
        data: histos[desc[0]][0].map((x) => x.doc_count),
        lineTension: 0.5,
        pointBorderColor: desc[1].pointBorderColor,
        pointBackgroundColor: desc[1].pointBackgroundColor,
        backgroundColor: desc[1].backgroundColor,
        borderColor: desc[1].borderColor
      })
    })
    // merge ChangeCommitForcePushedEvent and ChangeCommitPushedEvent together
    const merged = []
    for (
      let idx = 0;
      idx < histos.ChangeCommitForcePushedEvent[0].length;
      idx++
    ) {
      const d1 = histos.ChangeCommitForcePushedEvent[0][idx]
      const d2 = histos.ChangeCommitPushedEvent[0][idx]
      merged.push(d1.doc_count + d2.doc_count)
    }
    data.datasets.push({
      label: 'Updated',
      data: merged,
      lineTension: 0.5,
      pointBorderColor: 'rgba(' + updatedColor + ',1)',
      pointBackgroundColor: '#fff',
      backgroundColor: 'rgba(' + updatedColor + ',0.4)',
      borderColor: 'rgba(' + updatedColor + ',1)'
    })
    return data
  }

  render() {
    const data = this.prepareDataSet(this.props.data)
    return (
      <Row>
        {/* <Col md={{ span: 8, offset: 2 }}> */}
        <Col>
          <Card>
            <Card.Body>
              <Line
                data={data}
                width={100}
                // on small screen the legend takes the whole height so detect and adjust
                height={hasSmallWidth() ? 90 : 68}
                options={{
                  legend: {
                    labels: {
                      boxWidth: 30
                    }
                  }
                }}
              />
            </Card.Body>
          </Card>
        </Col>
      </Row>
    )
  }
}

ChangeLifeCycleEventsHisto.propTypes = {
  data: PropTypes.shape({
    ChangeAbandonedEvent: PropTypes.array,
    ChangeCreatedEvent: PropTypes.array,
    ChangeMergedEvent: PropTypes.array,
    ChangeCommitForcePushedEvent: PropTypes.array
  })
}

const CChangesLifeCycleStats = (props) => (
  <Row>
    <Col>
      <Card>
        <Card.Header>
          <Card.Title>Changes lifecycle stats</Card.Title>
        </Card.Header>
        <Card.Body>
          <Row>
            <Col md={4}>
              <ListGroup>
                <ListGroup.Item>
                  {props.data.ChangeCreatedEvent.events_count} changes created
                  by {props.data.ChangeCreatedEvent.authors_count} authors
                </ListGroup.Item>
                <ListGroup.Item>
                  <Link to={'/' + props.index + '/changes?state=OPEN'}>
                    {props.data.opened} opened changes
                  </Link>
                </ListGroup.Item>
                <ListGroup.Item>
                  <Link to={'/' + props.index + '/changes?state=CLOSED'}>
                    {props.data.abandoned} changes abandoned:{' '}
                    {props.data.ratios['abandoned/created']}%
                  </Link>
                </ListGroup.Item>
                <ListGroup.Item>
                  <Link to={'/' + props.index + '/changes?state=MERGED'}>
                    {props.data.merged} changes merged:{' '}
                    {props.data.ratios['merged/created']}%
                  </Link>
                </ListGroup.Item>
                <ListGroup.Item>
                  <Link to={'/' + props.index + '/changes?state=SELF-MERGED'}>
                    {props.data.self_merged} changes self merged:{' '}
                    {props.data.ratios['self_merged/created']}%
                  </Link>
                </ListGroup.Item>
                <ListGroup.Item>
                  Mean Time To Merge:{' '}
                  {moment.duration(props.data.duration, 'seconds').humanize()}
                </ListGroup.Item>
                <ListGroup.Item>
                  Median Deviation of TTM:{' '}
                  {moment
                    .duration(props.data.duration_variability, 'seconds')
                    .humanize()}
                </ListGroup.Item>
                <ListGroup.Item>
                  {props.data.ChangeCommitForcePushedEvent.events_count +
                    props.data.ChangeCommitPushedEvent.events_count}{' '}
                  updates of changes
                </ListGroup.Item>
                <ListGroup.Item>
                  Changes with tests: {props.data.tests}%
                </ListGroup.Item>
                <ListGroup.Item>
                  {props.data.ratios['iterations/created']} iterations per
                  change
                </ListGroup.Item>
                <ListGroup.Item>
                  {props.data.commits ? props.data.commits.toFixed(2) : 'no'}{' '}
                  commits per change
                </ListGroup.Item>
              </ListGroup>
            </Col>
            <Col md={8}>
              <ChangeLifeCycleEventsHisto data={props.data.histos} />
            </Col>
          </Row>
        </Card.Body>
      </Card>
    </Col>
  </Row>
)

export { CChangesLifeCycleStats }
