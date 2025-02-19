#!/bin/env bash
# original source: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator
# taken from here: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

# See README.md for usage instructions
bar_color="#7f7fff"
volume_step=2
brightness_step=2
max_volume=150

# Uses regex to get volume from pactl
function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'
}

# Uses regex to get mute status from pactl
function get_mute {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o 'MUTED'
}

# Uses regex to get brightness from xbacklight
function get_brightness {
    brightnessctl | awk 'NR==2 {print $NF}' | tr -d '(%)' ;
}

# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_volume_icon {
    volume=$(get_volume)
    volume=$(echo "$volume * 100 / 1" | bc)
    echo 'get_volume_icon'
    echo $volume
    mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon="  "
    elif [ "$volume" -lt 50 ]; then
        volume_icon="  "
    else
        volume_icon="  "
    fi
}

# Always returns the same icon - I couldn't get the brightness-low icon to work with fontawesome
function get_brightness_icon {
    brightness_icon=""
}

# Displays a volume notification using dunstify
function show_volume_notif {
    volume=$(get_volume)
    volume=$(echo "$volume * 100 / 1" | bc)
    echo 'show_volume_notif'
    echo $volume
    get_volume_icon
    dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal "$( [ -z $(get_mute) ] && echo "$volume_icon $volume%" || echo "   $volume% [MUTED]" )" -h int:value:$volume -h string:hlcolor:$([[ volume -ge 100 ]] && echo '#f90206' || echo "$bar_color" )
}

# Displays a brightness notification using dunstify
function show_brightness_notif {
    brightness=$(get_brightness)
    get_brightness_icon
    dunstify -t 1000 -r 2593 -u normal "$brightness_icon  $brightness%" -h int:value:$brightness -h string:hlcolor:$bar_color
}

# Main function - Takes user input, "volume_up", "volume_down", "brightness_up", or "brightness_down"
case $1 in
    volume_up)
    # Unmutes and increases volume, then displays the notification
    # pactl set-sink-mute @DEFAULT_SINK@ 0
    # wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    volume=$(get_volume)
    volume=$(echo "$volume * 100 / 1" | bc)
    echo 'main'
    # echo $volume
    echo $(echo "$volume + $volume_step" | bc)
    if [ $( echo "$volume + $volume_step" | bc ) -gt $max_volume ]; then
        # pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
        echo "Hello, World !!!"
        wpctl set-volume @DEFAULT_AUDIO_SINK@ $max_volume%
    else
        # pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
        wpctl set-volume @DEFAULT_AUDIO_SINK@ $volume_step%+
    fi
    show_volume_notif
    ;;

    volume_down)
    # Raises volume and displays the notification
    # pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
    wpctl set-volume @DEFAULT_AUDIO_SINK@ $volume_step%-
    show_volume_notif
    ;;

    volume_mute)
    # Toggles mute and displays the notification
    # pactl set-sink-mute @DEFAULT_SINK@ toggle
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    show_volume_notif
    ;;

    brightness_up)
    # Increases brightness and displays the notification
    brightnessctl set +$brightness_step%
    show_brightness_notif
    ;;

    brightness_down)
    # Decreases brightness and displays the notification
    brightnessctl set $brightness_step%-
    show_brightness_notif
    ;;
esac
