#!/usr/bin/env bash

set -eu -o pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <Docker project name>"
  exit 1
fi

script_dir=$(dirname "$0")
project_name=$1
project_path="${script_dir}/../dockerfiles/${project_name}"

# Determining Docker project parameters
repository=$(yq -r .repository "${project_path}/properties.yml")
tag=$(yq -r .tag "${project_path}/properties.yml")
version=$(yq -r .version "${project_path}/properties.yml")
platforms=$(yq -r .platforms "${project_path}/properties.yml")

# Build Docker image
echo "Building Docker image ${repository}:${tag}"
docker buildx build \
  --file "${project_path}/Dockerfile" \
  --build-arg APPVERSION="$version" \
  --platform "$platforms" \
  --tag "${repository}:${tag}" \
  --push \
  "$project_path"
