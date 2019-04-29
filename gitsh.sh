#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Parameters:
#   $1 - Initial date
#     type: String - ISO8601 date
#     default: <one day ago>
#   
#   $2 - Final date
#     type: String - ISO8601 date
#     default: <current day>
#
#   $3 - Number of pages of GitHub API should be parsed
#     type: Number
#     default: 2
#
# Logic:
#   This script will get all PRs between $1 and $2 and check if the author is
#   not a part of the team. There is a prepopulated file ($AUTHORS_PATH) that
#   contains all git users that compose the team.
#
# Ouput:
#   TODO
# ------------------------------------------------------------------------------

source ./http.sh
source ./date.sh
source ./pull_requests.sh

# Parse arg $3 - number of pages to query
PAGES_COUNT=$3
DOWNLOAD_PAGES=${PAGES_COUNT:="2"}

# Get date range for query. If initial parameters are not set, use defaults
INITIAL_DATE=$1
FINAL_DATE=$2
INITIAL_DATE_EPOCH=$(date_epoch ${INITIAL_DATE:="yesterday"})
FINAL_DATE_EPOCH=$(date_epoch ${FINAL_DATE:="today"})

# Get Pull Requests from GitHub
http_download_pull_requests $DOWNLOAD_PAGES
PR_COUNT=$(pull_requests_count)

touch _output.txt
for (( i=0; i<$PR_COUNT; i++ )); do
	PR_CREATED_AT_RAW=$(pull_requests_created_at $i)
	PR_CREATED_AT_EPOCH=$(date_epoch $PR_CREATED_AT_RAW)

  # if PR date is between initial date and final date
	if (( $PR_CREATED_AT_EPOCH > $INITIAL_DATE_EPOCH \
				&& $PR_CREATED_AT_EPOCH < $FINAL_DATE_EPOCH ));
	then
		echo $(pull_requests_author $i) >> _output.txt
	fi
done

cat _output.txt | sort | uniq -c
rm _output.txt

exit 0
