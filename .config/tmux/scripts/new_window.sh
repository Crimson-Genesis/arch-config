#!/usr/bin/bash

# Get the number of windows in the current tmux session
window_count=$(tmux list-windows | wc -l)

if [ "$window_count" -eq 1 ]; then
    # If only one window is open, create a new window with the name $SHELL
    tmux new-window -n "TERMINAL"
else
    # Otherwise, find the highest Test-n window and increment the number
    max_test_num=$(tmux list-windows | grep -o 'Test-[0-9]\+' | grep -o '[0-9]\+' | sort -n | tail -1)

    # If no Test windows are found, set the number to 1
    if [ -z "$max_test_num" ]; then
        next_test_num=1
    else
        next_test_num=$((max_test_num + 1))
    fi

    # Create a new window with the name Test-n
    tmux new-window -n "Test-$next_test_num"
fi

