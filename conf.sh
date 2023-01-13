# Container image
GIT_HASH="$(git -C $DIR describe --dirty --always)"
TAG="$GIT_HASH"
IMAGE="gitlab-registry.in2p3.fr/astrolabsoftware/fink/fink-alert-simulator:$TAG"

# Used for development purpose (i.e. with telepresence)
DEV_IMAGE="astrolabsoftware/fink/fink/fink-alert-simulator-devps"

# Used for integration tests
FINK_BROKER_DIR="/tmp/fink-broker"