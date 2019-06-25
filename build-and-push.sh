#!/bin/bash
set -eou pipefail

IMAGE="place1/kube-tools:$(date +%Y.%m.%d)"

docker build -t "$IMAGE" .
docker push "$IMAGE"
