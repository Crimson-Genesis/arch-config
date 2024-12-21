#!/usr/bin/env bash

# Add this script to your wm startup file.
DIR="$HOME/.config/polybar"

if pgrep -x "polybar" > /dev/null; then
    killall -q polybar
else
    # Wait until the processes have been shut down
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
    polybar mybar &
fi
