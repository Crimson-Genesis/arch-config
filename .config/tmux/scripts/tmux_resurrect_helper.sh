#!/usr/bin/env bash

save() {
    if [[ -z $TMUX ]]; then
        tmux "~/.config/tmux/plugins/tmux-resurrect/scripts/save.sh"
    fi
} 2> /dev/null

restore() {
    if [[ -z $TMUX ]]; then
        tmux new-session "exec ~/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh 2> /dev/null"
    else
        exec "~/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh" 2> /dev/null
    fi
} 2> /dev/null

$1
