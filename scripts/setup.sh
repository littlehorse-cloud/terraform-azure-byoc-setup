#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Use: $0 <REPOSITORY_NAME>"
  exit 1
fi

REPOSITORY_NAME="$1"
ORGANIZATION_NAME="littlehorse-cloud"

MODULE_VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/littlehorse-cloud/terraform-azure-byoc-setup.git | grep -v '\^{}' | tail -n1 | sed 's/.*\///; s/^v//')"

WORKDIR="tf-byoc-module"

# if workdir exists then exit with error
if [ -d "$WORKDIR" ]; then
  echo "Error: There is an existing state, if you want to preserve state then run terraform from within ./$WORKDIR folder, otherwise delete the folder and try again."
  exit 1
fi

mkdir -p "$WORKDIR"
cd "$WORKDIR"
