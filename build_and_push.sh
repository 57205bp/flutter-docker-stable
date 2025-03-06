#!/bin/bash
set -e

echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

docker buildx build --platform linux/amd64,linux/arm64 --push \
   --tag ghcr.io/YOUR_GHCR_USERNAME/flutter:stable \
   --build-arg flutter_version=3.29.0 \
   sdk