#!/bin/bash
set -eou pipefail

docker pull docker:stable

IMAGE="place1/kube-tools:$(date +%Y.%m.%d)"

docker login
docker build -t "$IMAGE" .
docker push "$IMAGE"

echo "New image pushed: $IMAGE"
