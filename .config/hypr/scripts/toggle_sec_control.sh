#!/usr/bin/env bash

if pgrep -f god-controller >/dev/null; then
    pkill -f god-controller
else
   (exec -a "god-controller" ~/.config/hypr/scripts/opener secontroller)
fi

