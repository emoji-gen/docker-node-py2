#!/bin/bash

set -eu -o pipefail

NODE_VERSION=$(fgrep 'node:' Dockerfile | sed -E 's/^.*node\:([0-9\.]+).*$/\1/')
PYTHON_VERSION=$(fgrep 'python:' Dockerfile | sed -E 's/^.*python\:([0-9\.]+).*$/\1/')
TAG_NAME="node$NODE_VERSION-py$PYTHON_VERSION"

docker tag $DOCKER_OWNER/$DOCKER_IMAGE:latest $DOCKER_OWNER/$DOCKER_IMAGE:$TAG_NAME
docker push $DOCKER_OWNER/$DOCKER_IMAGE
docker push $DOCKER_OWNER/$DOCKER_IMAGE:$TAG_NAME
