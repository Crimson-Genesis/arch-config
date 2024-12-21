#!/usr/bin/env bash

# Check if a device is connected by bluetooth using bluetoothctl
info=$(bluetoothctl info | grep Name)

# Show some output when it is
if bluetoothctl show | grep -q "Powered: yes"; then
    if echo "$info" | grep -q "Name"; then
        # Connected to a device
        info="${info##*: }"
        echo "%{F#7aa2f7}󰂯 %{F#C5C8C6}$info"
    else 
        # Not connected to a device, hide label
        echo "%{F#7aa2f7}󰂯 %{F#707880}Not Connected"
    fi
else
    echo '%{F#707880}󰂲 %{F#707880}Off'
fi
