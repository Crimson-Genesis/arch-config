#!/usr/bin/env bash

make_gitignore(){
    local dir_names=$(find . -mindepth 1 -type d | sed "s/^..\(.*\)/\1\//g" | sort)
    local file_names=$(find . -type f | sed "s/^..\(.*\)/\1/g" | sort)
    # printf "%s\n" $dir_names
    # printf "%s\n" $file_names
    local paths=$(printf "%s\n" "$dir_names$file_names" | awk -F'/' '
    {
        if ($0 ~ /\/$/) { # Check if it is a directory (ends with `/`)
            dirs[$1] = dirs[$1] $0 "\n"
        } else {          # Otherwise, treat it as a file
        files[$1] = files[$1] $0 "\n"
        }
    }
    END {
    # Print grouped files
    for (dir in files) {
        printf files[dir]
        print ""
    }
    # Print grouped directories
    for (dir in dirs) {
        printf dirs[dir]
        print ""
    }
    }')

    local data=$(printf "%s\n" $paths | fzf --multi --reverse)
    if [ -s ".gitignore" ];then
        cp ./.gitignore ./.gitignore.bak
    else
        echo "*" > ./.gitignore
    fi
    local gitignore_data=$(sed -n "2,\$s/^.\(.*\)/\1/p" ./.gitignore)
    printf "%s\n" $gitignore_data
    if [[ ! -z $data ]]; then
        printf "!%s\n" $data >> ./.gitignore
    else
        rm ./.gitignore
    fi

}
make_gitignore
