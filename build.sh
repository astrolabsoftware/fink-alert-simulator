#!/bin/bash

# Create container image containing fink-alert-simulator for k8s

# @author  Fabrice Jammes

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)

# This will avoid overriding user ciuxconfig during a build

CIUXCONFIG=${CIUXCONFIG:-$HOME/.ciux/ciux.fink-alert-simulator.sh}
export CIUXCONFIG

usage() {
  cat << EOD

Usage: `basename $0` [options]

  Available options:
    -h          this message

Build image containing fink-alert-simulator for k8s
EOD
}

# get the options
while getopts h c ; do
    case $c in
	    h) usage ; exit 0 ;;
	    \?) usage ; exit 2 ;;
    esac
done
shift `expr $OPTIND - 1`

# This command avoid retrieving build dependencies if not needed
ciux ignite --main $DIR
. $CIUXCONFIG

if [ $CIUX_BUILD = false ];
then
    echo "Build cancelled, image $CIUX_IMAGE_URL already exists and contains current source code"
    exit 0
fi

# This command will retrieve build dependencies
ciux ignite $DIR
. $CIUXCONFIG

# Build image
docker image build --tag "$CIUX_IMAGE_URL"

echo "Build successful"

