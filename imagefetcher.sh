#!/bin/bash

# Check if jq and curl are installed
if ! command -v jq &> /dev/null || ! command -v curl &> /dev/null; then
    echo "jq and curl are required. Please install them before running this script."
    exit 1
fi

# Get the Docker registry IP from command-line argument
registry_ip=$1

# Ensure the registry IP is provided
if [ -z "$registry_ip" ]; then
    echo "Usage: $0 <registry_ip>"
    exit 1
fi

# Docker registry URL
registry_url="http://${registry_ip}:5000/v2"

# Get the list of repositories
repositories=$(curl -s "${registry_url}/_catalog" | jq -r '.repositories[]')

# Loop through each repository and pull its images
for repo in $repositories; do
  # Get the list of tags for the current repository
  tags=$(curl -s "${registry_url}/${repo}/tags/list" | jq -r '.tags[]')

  # Loop through each tag and pull the image
  for tag in $tags; do
    image="${repo}:${tag}"
    echo "Pulling image: ${image}"
    docker pull "${registry_ip}:5000/${repo}:${tag}"
  done
done

echo "All images downloaded successfully."
