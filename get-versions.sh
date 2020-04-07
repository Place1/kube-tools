#!/bin/bash

function tags {
  local repo="$1"
  echo "### $repo"
  curl -L --silent https://api.github.com/repos/$repo/tags | jq -r '.[].name' | head -n 5 | tr ' ' '\n'
  echo ""
}

tags kubernetes/kubectl
tags GoogleContainerTools/skaffold
tags helm/helm
tags pulumi/pulumi
tags hashicorp/vault
tags instrumenta/kubeval
