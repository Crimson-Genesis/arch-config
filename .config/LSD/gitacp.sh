#!usr/bin/env bash

status=$(git status -s)

if [ ! -z "$status" ]; then
    diff="$(git diff)"
    if [ ! -z "$diff" ]; then
        git diff | bat
    else
        git status | bat
    fi
    read -e -p "message: " message
    read -e -p "Confirm Push (Y|n):- " confirm

    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]] || [[ "$confirm" == "" ]]; then
        git add . && \
        git commit -m "$message" -m "$(git diff --stat)" && \
        git push -u origin main
    else
        echo "CANCELING THE GIT PUSH PROCESS..."
    fi
else
    echo -e "\e[31mNOTHING TO COMMIT.\e[0m"
fi
exit
