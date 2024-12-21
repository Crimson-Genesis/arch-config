#!/usr/bin/env bash

# Formatting helpers
CHARGE=$(acpi | awk -F ',' '{ print $2}' | tr -d " %")
# IS_CHARGING=$(echo "$BATTERY_INFO" | awk -F )

ICON=""

# Format battery icon, depending on the status.
if [[ $(acpi -a) == "Adapter 0: on-line" ]]; then
    ICON="  " # Plug icon, font awesome.
else
    if [[ $CHARGE -lt 10 ]]; then
        ICON="󰁺  "
    elif [[ $CHARGE -lt 20 ]]; then
        ICON="󰁻  "
    elif [[ $CHARGE -lt 30 ]]; then
        ICON="󰁼  "
    elif [[ $CHARGE -lt 40 ]]; then
        ICON="󰁽  "
    elif [[ $CHARGE -lt 50 ]]; then
        ICON="󰁾  "
    elif [[ $CHARGE -lt 60 ]]; then
        ICON="󰁿  "
    elif [[ $CHARGE -lt 70 ]]; then
        ICON="󰂀  "
    elif [[ $CHARGE -lt 80 ]]; then
        ICON="󰂁  "
    elif [[ $CHARGE -lt 90 ]]; then
        ICON="󰂂  "
    else
        ICON="󰁹  "
    fi
fi

# Format charge & color depending on the status.
FORMAT="%{F#7aa2f7}$ICON %{F#C5C8C6}$CHARGE%"

# Final formatted output.
echo $FORMAT

