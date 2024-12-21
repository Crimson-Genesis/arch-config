#!/usr/bin/env bash

# Create the png directory if it doesn't exist
mkdir -p png

# convert "$IMAGE" -resize "$SCREEN_RESOLUTION^" -gravity center -extent "$SCREEN_RESOLUTION" "$RESIZED_IMAGE"

SCREEN_RESOLUTION=$(xdpyinfo | grep dimensions | awk '{print $2}')

# Loop through all jpg files in the current directory
for file in *.jpg; do
  # Extract the base filename without the extension
  base=$(basename "$file" .jpg)
  # Convert the file to png format and save it in the png directory
  magick "$file" -resize "$SCREEN_RESOLUTION" "png/${base}.png"
  echo "$file Converted to png/${base}.png at $SCREEN_RESOLUTION"
done
