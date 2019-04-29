# github_prs_by_contributors

Get a list of PRs closed grouped by authors

# Environment preparation

## Programs

Besides the basic UNIX programs for handling file system operations, you'll need to have the following CLI installed:

- curl
- gdate
- jq

## Variables

You'll need the following variables on your environment:

```sh
# secret
GITHUB_TOKEN=<your token>

# GitHub config
GIT_REPO=my_repo
GIT_ORG=my_org

# Project config
PULL_REQUESTS_PATH=_pull_requests.json # used for maintaining pull requests returned from GitHub API
```

The recommended way of doing that is to use a `.env` file

# Usage

See **Environment preparation** section before running the program.

Example:

```sh
./get_contributors.sh 2018-06-01 2019-03-31 15
```

The command above will get Pull Requests created between `2018-06-01` and `2019-03-31` and the script will make `15` requests. These requests correspond to the number of pages you'll query. If you need a longer period, the number of pages need to increase.

For more details on the parameters, refer to `get_contributors.sh`.
