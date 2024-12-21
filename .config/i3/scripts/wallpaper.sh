#!/bin/bash

# Path to your MP4 file
VIDEO_PATH="/run/media/zero/Nova/Wallpaper/yae-miko-pixel-art2.3840x2160.mp4"

xwinwrap -fs -ov -- mpv --no-border --loop --framedrop --really-quiet "$VIDEO_PATH"

