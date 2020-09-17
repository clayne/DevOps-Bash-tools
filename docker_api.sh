#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: https://hub.docker.com/v2/repositories/harisekhon/hbase/tags | jq .
#
#  Author: Hari Sekhon
#  Date: 2020-09-14 15:25:12 +0100 (Mon, 14 Sep 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "${BASH_SOURCE[0]}")"

# shellcheck disable=SC1090
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Queries a Docker Registry API v2

Sends basic HTTP authentication if the following environment variables are defined:

\$DOCKER_USERNAME / \$DOCKER_USER
\$DOCKER_PASSWORD / \$DOCKER_TOKEN

Can specify \$CURL_OPTS for options to pass to curl or provide them as arguments


API Reference:

https://docs.docker.com/registry/spec/api/


Examples:

# Get all the tags for a given repository called 'harisekhon/hbase' on DockerHub's public registry:

${0##*/} https://hub.docker.com/v2/repositories/harisekhon/hbase/tags
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="https://host:port/v2/... [<curl_options>]"

CURL_OPTS="-sS --fail --connect-timeout 3 ${CURL_OPTS:-}"

help_usage "$@"

min_args 1 "$@"

user="${DOCKER_USERNAME:-${DOCKER_USER:-}}"
PASSWORD="${DOCKER_PASSWORD:-${DOCKER_TOKEN:-}}"

if [ -n "$user" ]; then
    export USERNAME="$user"
fi
export PASSWORD

url="$1"
shift || :

"$srcdir/curl_auth.sh" "$url" "$@" $CURL_OPTS