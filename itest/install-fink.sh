#!/bin/bash

# Install Fink broker and its dependencies

# @author Fabrice Jammes SLAC/IN2P3

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. $DIR/../conf.sh

if [ -d "$FINK_BROKER_DIR" ]; then
  rm -rf "$FINK_BROKER_DIR"
fi

REPO_URL="https://github.com/astrolabsoftware/fink-k8s"

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCH=${GHA_BRANCH_NAME:-$GIT_BRANCH}
# Retrieve same fink-k8s branch if it exists, else use main branch
if git ls-remote --exit-code --heads "$REPO_URL" "$BRANCH"
then
    FINK_BROKER_VERSION="$BRANCH"
else
    FINK_BROKER_VERSION="main"
fi

git clone "$REPO_URL" --branch "$FINK_BROKER_VERSION" \
  --single-branch --depth=1 "$FINK_BROKER_DIR"
"$FINK_BROKER_DIR"/bin/strimzi-install.sh
"$FINK_BROKER_DIR"/bin/strimzi-setup.sh
"$FINK_BROKER_DIR"/bin/prereq-install.sh
