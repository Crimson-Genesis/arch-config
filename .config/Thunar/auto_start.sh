#!/usr/bin/env bash

ws1="3:"

thunar_count=$(i3-msg -t get_tree | jq '[recurse(.nodes[]?) | select(.nodes? and .name == "3:").nodes[] | recurse(.nodes[]?) | select(.window_properties.class == "Thunar")] | length')
echo $thunar_count

if [ "$thunar_count" -eq 0 ]; then
    i3-msg "workspace 3:, exec thunar"
else
    i3-msg "workspace 3:"
fi
