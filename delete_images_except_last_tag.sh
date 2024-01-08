#!/bin/bash

# Fetch all unique image names
image_names=$(docker images --format "{{.Repository}}" | sort -u)

# Loop through each image name
while read -r image_name; do
  # Fetch all tags for the current image
  tags=$(docker images --format "{{.Tag}}" "$image_name" | sort)

  # Skip images with only one tag
  if [ $(echo "$tags" | wc -l) -le 1 ]; then
    echo "Skipping image $image_name as it has only one tag."
    continue
  fi

  # Get the last tag
  last_tag=$(echo "$tags" | tail -n 1)

  # Loop through each tag, except the last one, and delete the image
  while read -r tag; do
    if [ "$tag" != "$last_tag" ]; then
      echo "Deleting image: $image_name:$tag"
      docker rmi "$image_name:$tag"
    fi
  done <<< "$tags"

  echo "For image $image_name, last tag ($last_tag) is retained. All other tags deleted."

done <<< "$image_names"
