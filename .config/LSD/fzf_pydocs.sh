#!/usr/bin/bash

search=$(cat '/home/zero/.config/LSD/.modules_list.txt' | fzf --reverse --print-query)
searched=$(echo "$search" | head -n 1)
selected=$(echo "$search" | tail -n 1)


if [[ "$searched" == */ ]]; then
    pydoc ${searched%/}
else
    if [ ! -z "$selected" ]; then
        pydoc $selected
    fi
fi
