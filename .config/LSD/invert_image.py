#!/usr/bin/env python

import os
from PIL import Image, ImageOps

# Define directories
input_dir = os.getcwd()  # Current directory as input
output_dir = os.path.join(input_dir, "inverted")

# Create output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Process all images in the directory
for filename in os.listdir(input_dir):
    if filename.lower().endswith((".png", ".jpg", ".jpeg", ".bmp", ".tiff")):
        img_path = os.path.join(input_dir, filename)
        img = Image.open(img_path).convert("RGB")  # Convert to RGB to avoid issues
        inverted_img = ImageOps.invert(img)
        inverted_img.save(os.path.join(output_dir, filename))
        print(f"Inverted: {filename}")

print("All images inverted successfully!")

