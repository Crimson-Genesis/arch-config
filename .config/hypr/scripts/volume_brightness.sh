#!/bin/env bash

bar_color="#7f7fff"
volume_step=2
brightness_step=2
max_volume=150

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

get_mute() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q 'MUTED' && echo "yes" || echo "no"
}

get_brightness() {
    brightnessctl g | awk -v max=$(brightnessctl m) '{print int(($1/max)*100)}'
}

get_volume_icon() {
    volume=$(get_volume)
    mute=$(get_mute)

    if [[ "$mute" == "yes" || "$volume" -eq 0 ]]; then
        echo "🔇"  # Use a safe Unicode icon
    elif [[ "$volume" -lt 50 ]]; then
        echo "🔉"
    else
        echo "🔊"
    fi
}

get_brightness_icon() {
    echo "☀️"
}

show_volume_notif() {
    volume=$(get_volume)
    mute=$(get_mute)
    volume_icon=$(get_volume_icon)

    if [[ -z "$volume" || ! "$volume" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid volume value '$volume'" >&2
        return
    fi

    if [[ "$mute" == "yes" ]]; then
        notify-send -i audio-volume-muted-blocking -t 1000 -r 1001 -u normal "🔇  $volume% [MUTED]" -h int:value:$volume
    else
        notify-send -i audio-volume-medium -t 1000 -r 1001 -u normal "$volume_icon  $volume%" -h int:value:$volume
    fi
}

show_brightness_notif() {
    brightness=$(get_brightness)
    brightness_icon=$(get_brightness_icon)

    if [[ -z "$brightness" || ! "$brightness" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid brightness value '$brightness'" >&2
        return
    fi

    notify-send -i display-brightness -t 1000 -r 1001 -u normal "$brightness_icon  $brightness%" -h int:value:$brightness
}

case $1 in
    volume_up)
        volume=$(get_volume)
        if (( volume + volume_step > max_volume )); then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ ${max_volume}%
        else
            wpctl set-volume @DEFAULT_AUDIO_SINK@ ${volume_step}%+
        fi
        show_volume_notif
        ;;

    volume_down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${volume_step}%-
        show_volume_notif
        ;;

    volume_mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        show_volume_notif
        ;;

    brightness_up)
        brightnessctl set +${brightness_step}%
        show_brightness_notif
        ;;

    brightness_down)
        brightnessctl set ${brightness_step}%-
        show_brightness_notif
        ;;
esac

