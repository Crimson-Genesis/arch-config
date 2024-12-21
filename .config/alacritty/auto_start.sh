#!/usr/bin/env bash

ws1="1:"

alacritty_count=$(i3-msg -t get_tree | jq '[recurse(.nodes[]?) | select(.nodes? and .name == "1:").nodes[] | recurse(.nodes[]?) | select(.window_properties.class == "Alacritty")] | length')
echo $alacritty_count

if [ "$alacritty_count" -eq 0 ]; then
    i3-msg "workspace 1:, exec alacritty"
else
    i3-msg "workspace 1:"
fi
