#!/usr/bin/bash
if [ ! -z $TMUX ] && [ -z $NVIM ]; then
    if [ 2 -eq "$(tmux display-message -p '#I')" ]; then
        clear
        tmux select-window -t 1
        exit 1
    elif [ 1 -eq "$(tmux display-message -p '#I')" ] && [ 1 -eq "$(tmux display-message -p '#{pane_index}')" ]; then
        clear
        tmux detach
        exit 1
    fi
fi
exit 0
