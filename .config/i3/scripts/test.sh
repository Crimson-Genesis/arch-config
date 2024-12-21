# #!/bin/bash
#
# # List of applications and their respective workspaces
# declare -A apps
# apps=(
#     ["Alacritty"]="1"
#     ["Firefox"]="2"
#     ["Chromium"]="3"
#     ["code"]="4"
#     ["default"]="10"
# )
#
# # Use rofi in drun mode to select an application
# app=$(rofi -show drun -dmenu -p "Open application in workspace")
# echo $app
# # Extract the application name (remove spaces and any non-alphanumeric characters)
# app_name=$(echo "$app" | sed 's/[^a-zA-Z0-9]//g')
# echo $app_name
# # Get the workspace for the selected application, default to "default"
# workspace=${apps[$app_name]:-${apps["default"]}}
# echo $workspace
#
# # # Launch the application
# # i3-msg "exec $app"
# #
# # # Wait for the application window to appear and move it to the specified workspace
# # sleep 0.5
# # i3-msg "[class=\"${app_name}\"] move container to workspace $workspace"
# # i3-msg "workspace $workspace"

#!/bin/bash

# Use Rofi in 'drun' mode to list all applications
selected=$(rofi -show drun -dmenu -i -p "Search Applications:")

# Echo the selected application
echo "$selected"

