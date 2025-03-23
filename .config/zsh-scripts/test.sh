function mirror(){
    if [[ 'on' == $1 ]]; then
        # hyprctl keyword monitor "eDP-1, 1920x1080@30, auto, 1, mirror, HDMI-A-1"
        echo 'on'
    elif [[ 'off' == $1 ]]; then
        # hyprctl keyword monitor "HDMI-A-1, disable"
        echo 'off'
    else 
        echo 'Invalid Value.'
    fi
}
