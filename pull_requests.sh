#!/usr/bin/env bash

pull_requests_count () {
  echo $(cat $PULL_REQUESTS_PATH | jq length)
}

pull_requests_created_at () {
  echo $(cat _pull_requests.json | jq -r ".[$1].created_at")
}

pull_requests_author () {
  echo $(cat _pull_requests.json | jq -r ".[$1].user.login")
}
