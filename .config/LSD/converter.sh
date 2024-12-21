#!/bin/bash

# Create the output directory if it doesn't exist
mkdir -p converted

# Loop through all .swf files in the current directory
for swf_file in *.swf; do
    # Skip if no .swf files are found
    [ -e "$swf_file" ] || continue

    # Get the base filename without the extension
    base_name="${swf_file%.swf}"

    # Set the output file path
    output_file="./converted/${base_name}.mp4"

    # Convert the .swf to .mp4 using ffmpeg
    ffmpeg -i "$swf_file" -c:v libx264 -preset slow -crf 22 "$output_file"

    echo "Converted $swf_file to $output_file"
done

echo "Conversion complete! All files are saved in the ./converted directory."

