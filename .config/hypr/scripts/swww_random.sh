#!/usr/bin/env bash

WALLPAPER_DIR="/run/media/nico/nova/wallpaper/wallpapers-main/"

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Apply the selected wallpaper
# For the step, smaller values = more smooth. Default = 20
# For the frame rate, default is 30.
swww img "$WALLPAPER" --transition-step 20 --transition-fps 20
