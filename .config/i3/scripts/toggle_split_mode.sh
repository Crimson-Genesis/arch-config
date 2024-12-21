#!/usr/bin/env bash
#
# # Get the current workspace name
# current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).name')
# echo $current_workspace
#
# # Get the layout of the currently focused container
# current_layout=$(i3-msg -t get_tree | jq -r 'recurse(.nodes[]) | select(.focused == true) | .layout')
# echo $current_layout
#
#
# # Toggle the split mode
# if [ "$current_layout" == "splith" ]; then
#     i3-msg split v
# else
#     i3-msg split h
# fi
#

# Get the current split mode
split_mode=$(i3-msg -t get_config | grep 'set \$split_mode' | awk '{print $3}')
echo $split_mode

# Toggle the split mode
if [ "$split_mode" == "h" ]; then
    i3-msg split v
    i3-msg "exec --no-startup-id echo 'set \$split_mode v' | i3-msg -q"
else
    i3-msg split h
    i3-msg "exec --no-startup-id echo 'set \$split_mode h' | i3-msg -q"
fi

