#!/bin/bash
set -e

releases_json=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json)

get_latest_stable_version() {
    channel="stable"
    channel_hash=$(echo "$releases_json" | jq -r '.current_release.'"$channel"'')
    version=$(echo "$releases_json" | jq -r --arg HASH "$channel_hash" \
        '.releases[] | select(.hash == $HASH).version')
    if [ -z "$version" ]; then
        echo "Error fetching latest stable version"
        exit 1
    fi
    echo "$version"
}

stable_version=$(get_latest_stable_version)

echo "Latest stable version: $stable_version"

yq -i '(.docker_builder.env.matrix[] | select(.DOCKER_TAG == "stable") | .FLUTTER_VERSION) = env(stable_version)' ci_config.yml 
exit 0