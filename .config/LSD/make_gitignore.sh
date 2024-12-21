#!/usr/bin/env bash

make_gitignore(){
    local data=$(fzf --multi --reverse)

    if [ -s ".gitignore" ];then
        cp ./.gitignore ./.gitignore.bak
    else
        echo "*" > ./.gitignore
    fi

    if [[ ! -z $data ]]; then
        printf "!%s\n" $data >> ./.gitignore
    else
        rm ./.gitignore
    fi
}
make_gitignore
