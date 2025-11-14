#!/bin/bash

# Directory to store extracted files
DEST="../unzipped"

# Create base destination if not exists
mkdir -p "$DEST"

# Loop over all .zip files in current directory
for zipfile in *.zip; do
    # Skip if no zip files
    [ -e "$zipfile" ] || continue

    # Extract filename without extension
    name=$(basename "$zipfile" .zip)

    # Initial target directory
    target="$DEST/$name"

    # If the directory exists, append an incrementing number
    counter=1
    while [ -d "$target" ]; do
        target="${DEST}/${name}_$counter"
        ((counter++))
    done

    # Create the target directory
    mkdir -p "$target"

    # Unzip file into target directory
    echo "Unzipping '$zipfile' → '$target'"
    unzip -q "$zipfile" -d "$target"
done

