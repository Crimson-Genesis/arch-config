#!/usr/bin/env bash
if pgrep -f god-controller >/dev/null; then
    pkill -f god-controller
else
   (exec -a "god-controller" ~/.config/hypr/scripts/opener secontroller)
fi


# if pgrep -f god-controller >/dev/null; then
#     pkill -f god-controller
# else
#     (setsid -f bash -c 'exec -a god-controller ~/.config/hypr/scripts/opener secontroller' & ) >/dev/null 2>&1
# fi

# if pgrep -f god-controller >/dev/null; then
#     pkill -f god-controller
# else
#     nohup ~/.config/hypr/scripts/opener secontroller >/dev/null 2>&1 &
# fi

