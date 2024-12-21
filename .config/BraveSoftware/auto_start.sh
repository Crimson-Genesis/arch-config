#!/usr/bin/env bash

ws1="2:"

brave_count=$(i3-msg -t get_tree | jq '[recurse(.nodes[]?) | select(.nodes? and .name == "2:").nodes[] | recurse(.nodes[]?) | select(.window_properties.class == "Brave-browser")] | length')
echo $brave_count

if [ "$brave_count" -eq 0 ]; then
    i3-msg "workspace 2:, exec brave"
else
    i3-msg "workspace 2:"
fi
