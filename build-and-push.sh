#!/bin/bash
set -eou pipefail

IMAGE="place1/kube-tools:$(date +%Y.%m.%d)"

docker login
docker build -t "$IMAGE" .
docker push "$IMAGE"
