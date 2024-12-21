#!/usr/bin/env bash

ws1="1:"

wezterm_count=$(i3-msg -t get_tree | jq '[recurse(.nodes[]?) | select(.nodes? and .name == "1:").nodes[] | recurse(.nodes[]?) | select(.window_properties.class == "org.wezfurlong.wezterm")] | length')
echo $wezterm_count

if [ "$wezterm_count" -eq 0 ]; then
    i3-msg "workspace 1:, exec wezterm"
else
    i3-msg "workspace 1:"
fi
