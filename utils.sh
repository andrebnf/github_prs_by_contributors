#!/usr/bin/env bash

log_progress () {
  CURRENT="$1"
  TOTAL="$2"

  echo -ne "   $CURRENT of $TOTAL\r"
}

log_progress_clear () {
  echo -ne "\n\n"
}

date_epoch () {
  echo $(gdate +%s --date $1)
}

cleanup () {
  rm -f \
    _prs_tmp.json \
    _tmp_pull_requests.json \
    _pull_requests.json \
    _output.txt
}
