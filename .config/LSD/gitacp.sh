#!/usr/bin/env bash

function acp(){
    if [[ -z $3 ]]; then
        git add .
    else
        git add $3
    fi
    git commit -S -m "$1" -m "$(git diff --stat)"
    if [[ -z $2 ]]; then
        git push -u origin $(git branch | awk '$1 == "*" {print $2}')
    else
        git push -u origin ${2}
    fi
}

status=$(git status -s)

if [ ! -z "$status" ]; then
    diff="$(git diff)"
    if [ ! -z "$diff" ]; then
        git diff | bat
    else
        git status | bat
    fi

    echo "Changed files:"
    git diff --stat
    read -e -p "message: " message
    read -e -p "Add manully (y|N):- " will_add

    if [[ ${will_add,,} == "y" ]]; then
        changed_file_paths=$(git diff --name-only)
        chosen_file_path=$(printf "%s\n" $changed_file_paths | fzf --wrap --cycle --ansi --reverse --multi --header='Choose file to add:')
        chosen_absolute_path=$(printf "%s\n" $chosen_file_path | sed "s|^|$(git rev-parse --show-toplevel)/|")

        read -e -p "Confirm Push (Y|n):- " confirm
        if [[ ${confirm,,} == "y" ]] || [[ "$confirm" == "" ]]; then
            acp "$message" "$1" "$chosen_absolute_path"
        else
            echo "CANCELING THE GIT PUSH PROCESS..."
            exit 1
        fi
        exit
    fi

    read -e -p "Confirm Push (Y|n):- " confirm
    if [[ ${confirm,,} == "y" ]] || [[ "$confirm" == "" ]]; then
        acp "$message" "$1"
        exit
    else
        echo "CANCELING THE GIT PUSH PROCESS..."
        exit 1
    fi
else
    echo -e "\e[31mNOTHING TO COMMIT.\e[0m"
fi
