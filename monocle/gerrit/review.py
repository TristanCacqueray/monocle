# MIT License
# Copyright (c) 2019 Fabien Boucher

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import os
import logging
from datetime import datetime
import json


class ReviewesFetcher(object):

    log = logging.getLogger("monocle.ReviewesFetcher")

    def __init__(self):
        self.path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'sample.json')
        with open(self.path) as fd:
            self.raw_data = fd.read()
            self.data = json.loads(self.raw_data[4:])
        self.status_map = {
            'NEW': 'OPEN',
            'MERGED': 'MERGED',
            'ABANDONED': 'CLOSED'
        }

    def extract_objects(self, reviewes):
        def timedelta(start, end):
            print(start)
            print(end)
            format = "%Y-%m-%d %H:%M:%S"
            start = datetime.strptime(start, format)
            end = datetime.strptime(end, format)
            return int((start - end).total_seconds())

        def extract_pr_objects(review):
            objects = []
            change = {
                'type': 'Change',
                'id': review['id'],
                'number': review['_number'],
                'repository_prefix': review['project'].split('/')[0],
                'repository_fullname': review['project'],
                'repository_shortname': "/".join(
                    review['project'].split('/')[1:]),
                'author': "%s/%s" % (
                    review['owner']['name'], review['owner']['email']),
                'title': review['subject'],
                'updated_at': review['updated'][:-10],
                'created_at': review['created'][:-10],
                'merged_at': (
                    review.get('submitted')[:-10] if review.get('submitted')
                    else None),
                # Note(fbo): The mergeable field is sometime absent
                'mergeable': (True if review.get('mergeable') == 'true'
                              else False),
                'state': self.status_map[review['status']],
                # Note(fbo): Gerrit labels must be handled as Review
                'labels': [],
                # Note(fbo): Only one assignee possible by review on Gerrit
                'assignees': (["%s/%s" % (
                    review['assignee']['name'], review['assignee']['email'])]
                    if review.get('assignee') else [])
            }
            if change['state'] == 'CLOSED':
                # CLOSED means abandoned in that context
                # use updated_at date as closed_at
                change['closed_at'] = change['updated_at']
            if change['state'] == 'MERGED':
                change['closed_at'] = change['merged_at']
            if change['state'] in ('CLOSED', 'MERGED'):
                change['duration'] = timedelta(
                    change['closed_at'], change['created_at'])
            if change['state'] == 'MERGED':
                change['merged_by'] = "%s/%s" % (
                    review['submitter']['name'], review['submitter']['email'])
            else:
                change['merged_by'] = None
            objects.append(change)
            objects.append({
                'type': 'ChangeCreatedEvent',
                'id': 'CCE' + change['id'],
                'created_at': change['created_at'],
                'author': change['author'],
                'repository_prefix': change['repository_prefix'],
                'repository_fullname': change['repository_fullname'],
                'repository_shortname': change['repository_shortname'],
                'number': change['number'],
            })
            if change['state'] in ('MERGED', 'CLOSED'):
                objects.append({
                    'type': 'ChangeClosedEvent',
                    'id': 'CCLE' + change['id'],
                    'created_at': change['closed_at'],
                    'author': change['author'],
                    'repository_prefix': change['repository_prefix'],
                    'repository_fullname': change['repository_fullname'],
                    'repository_shortname': change['repository_shortname'],
                    'number': change['number'],
                })
            for comment in review['messages']:
                objects.append(
                    {
                        'type': 'ChangeCommentedEvent',
                        'id': comment['id'],
                        'created_at': comment['date'][:-10],
                        'author': "%s/%s" % (
                            comment['author']['name'],
                            comment['author']['email']),
                        'repository_prefix': change['repository_prefix'],
                        'repository_fullname': change['repository_fullname'],
                        'repository_shortname': change['repository_shortname'],
                        'number': change['number'],
                        'on_author': change['author'],
                    }
                )
            for label in review['labels']:
                for _review in review['labels'][label].get('all', []):
                    # If the date field exists then it means a review label
                    # has been set by someone
                    if 'date' in _review:
                        obj = {
                            'type': 'ChangeReviewedEvent',
                            'id': "%s_%s_%s_%s" % (
                                _review['date'][:-10].strip(' '), label,
                                _review['value'], _review['email']),
                            'created_at': _review['date'][:-10],
                            'author': "%s/%s" % (
                                _review['name'], _review['email']),
                            'repository_prefix': change[
                                'repository_prefix'],
                            'repository_fullname': change[
                                'repository_fullname'],
                            'repository_shortname': change[
                                'repository_shortname'],
                            'number': change['number'],
                            'on_author': change['author'],
                            'review_note': "%s%s" % (
                                label,
                                ("+%s" % _review['value']
                                 if not str(_review['value']).startswith('-')
                                 else _review['value']))
                        }
                        objects.append(obj)
            return objects

        objects = []
        for review in reviewes:
            try:
                objects.extend(extract_pr_objects(review))
            except Exception:
                self.log.exception(
                    "Unable to extract Review data: %s" % review)
        return objects


if __name__ == "__main__":
    a = ReviewesFetcher()
    print(a.extract_objects(a.data))