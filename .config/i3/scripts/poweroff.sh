chosen=$(printf "Lock\nSleep\nHibernate\nLogout\nRestart\nShutDown" | rofi -dmenu -i)

case "$chosen" in 
    "Lock") i3lock -i ~/wallpaper/png/wp9355922-black-4k-aesthetic-wallpapers.png && sleep 1 ;;
    "Sleep") systemctl suspend ;;
    "Hibernate") systemctl hibernate ;;
    "Logout") i3-msg exit ;;
    "Restart") systemctl reboot ;;
    "ShutDown") systemctl poweroff -i ;;
    *) exit 1 ;;
esac
