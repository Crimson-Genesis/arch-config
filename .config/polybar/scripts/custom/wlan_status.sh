#!/usr/bin/env bash

interface="wlan0"  # Replace with your Wi-Fi interface


if ! iwconfig "$interface" | grep -q "Tx-Power=off"; then
    if ! iwconfig "$interface" | grep -q "ESSID:off"; then
        essid=$(iwconfig "$interface" | awk -F '"' '/ESSID/ {print $2}')
        echo "%{F#7aa2f7}  %{F#C5C8C6}$essid"
    else
        echo "%{F#7aa2f7}  %{F#707880}Disconnected"
    fi
else
    echo "%{F#707880}󰖪  %{F#707880}Off"
fi

