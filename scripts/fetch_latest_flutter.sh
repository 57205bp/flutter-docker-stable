#!/bin/bash
set -e
releases_json=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json)
latest_version=$(echo "$releases_json" | jq -r '.current_release.stable')
echo "Latest stable Flutter version: $latest_version"