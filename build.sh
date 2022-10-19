#!/bin/bash

# Create docker image containing qserv-ingest

# @author  Fabrice Jammes

set -euo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. ./conf.sh

# Build ingest image
docker image build --tag "$IMAGE" "$DIR"
