#!/bin/bash

LINES=5

function tags {
  local repo="$1"
  echo "### $repo"
  curl -L --silent https://api.github.com/repos/$repo/tags | jq -r '.[].name' | head -n $LINES | tr ' ' '\n'
  echo ""
}

tags kubernetes/kubectl
tags GoogleContainerTools/skaffold
tags helm/helm
tags pulumi/pulumi
tags hashicorp/vault
