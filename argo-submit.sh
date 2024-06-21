#!/bin/bash

# Launch fink-alert-simulator workflow

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. $DIR/conf.sh

usage() {
  cat << EOD

Usage: `basename $0` [options] path host [host ...]

  Available options:
    -h          this message
    -t          Directory for input data parameters (located in $DIR/manifests), override OVERLAY environment variable (defined in env.sh)

  Launch fink-alert-simulator workflow

EOD
}

dest=''
user=''
entrypoint='main'
overlay='base'

NS="argo"

# get the options
while getopts hibst: c ; do
    case $c in
      h) usage ; exit 0 ;;
      t) overlay="${OPTARG}"  ;;
      \?) usage ; exit 2 ;;
    esac
done
shift `expr $OPTIND - 1`

if [ $# -ne 0 ] ; then
    usage
    exit 2
fi

cfg_path="$DIR/manifests/$overlay/configmap"

if [ ! -d "$cfg_path" ]; then
    echo "ERROR Invalid configuration path $cfg_path" 1>&2;
    exit 1
fi

kubectl apply -n "$NS" -k "$cfg_path"
argo submit --serviceaccount argo -n "$NS" -p image="$IMAGE" -p verbose=2 --entrypoint $entrypoint -vvv $DIR/manifests/workflow.yaml
