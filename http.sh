BASE_URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

http_download_pull_requests () {
  DOWNLOAD_PAGES=$1
  TEMP_PATH=_prs_tmp.json

  # always make first request
  echo $(http_get_page 1) > $PULL_REQUESTS_PATH

  touch $TEMP_PATH
  # make subsequent requests and merge them on the same file ($PULL_REQUESTS_PATH)
  for (( i=2; i<=$DOWNLOAD_PAGES; i++ )); do
    mv $PULL_REQUESTS_PATH "_tmp$PULL_REQUESTS_PATH"
    # get another page from API
    echo $(http_get_page $i) > $TEMP_PATH
    jq -s ".|flatten" "_tmp$PULL_REQUESTS_PATH" $TEMP_PATH > $PULL_REQUESTS_PATH
    rm "_tmp$PULL_REQUESTS_PATH"
  done
  rm $TEMP_PATH
}

http_get_page () {
  PAGE=$1
  curl -s \
    -H "${AUTH_HEADER}" \
    -H "${API_HEADER}" \
    -H "Content-Type: application/json" \
    "$BASE_URI/repos/$GIT_ORG/$GIT_REPO/pulls?state=close&page=$PAGE"
}
