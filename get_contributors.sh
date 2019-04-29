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
#   This script will get all the PRs closed between $1 and $2 and will group 
#   them by contributor's login
# ------------------------------------------------------------------------------

source ./http.sh
source ./pull_requests.sh
source ./utils.sh

cleanup

# Parse arg $3 - number of pages to query
PAGES_COUNT=$3
DOWNLOAD_PAGES=${PAGES_COUNT:="2"}

# Get date range for query. If initial parameters are not set, use defaults
INITIAL_DATE=$1
FINAL_DATE=$2
INITIAL_DATE_EPOCH=$(date_epoch ${INITIAL_DATE:="yesterday"})
FINAL_DATE_EPOCH=$(date_epoch ${FINAL_DATE:="today"})

# Get Pull Requests from GitHub and save to a json file
http_download_pull_requests $DOWNLOAD_PAGES
PR_COUNT=$(pull_requests_count)

# temp file used to store partial results
touch _output.txt

echo "Analysing PRs"
for (( i=0; i<$PR_COUNT; i++ )); do
	# Log progress to stdout
	log_progress $((i + 1)) $PR_COUNT

	PR_CREATED_AT_RAW=$(pull_requests_created_at $i)
	PR_CREATED_AT_EPOCH=$(date_epoch $PR_CREATED_AT_RAW)

  # if PR date is between initial date and final date
	if (( $PR_CREATED_AT_EPOCH > $INITIAL_DATE_EPOCH \
				&& $PR_CREATED_AT_EPOCH < $FINAL_DATE_EPOCH ));
	then
		echo $(pull_requests_author $i) >> _output.txt
	fi
done

log_progress_clear

echo "==== number of PRs closed by contributors:"
cat _output.txt | sort | uniq -c
rm _output.txt

exit 0
