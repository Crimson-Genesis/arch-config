#!/usr/bin/env bash

main(){
    local dir_paths=$(find . -mindepth 1 -type d | sed "s/^..\(.*\)/\1\//g" | sort)
    local file_paths=$(find . -type f | sed "s/^..\(.*\)/\1/g" | sort)
    local paths=$(echo "$file_paths $dir_paths")

    if [ -s ".gitignore" ];then
        cp ./.gitignore ./.gitignore.bak
        echo "*" > ./.gitignore
    else
        echo "*" > ./.gitignore
    fi

    local gitignore_data=$(sed -n "2,\$s/^.\(.*\)/\1/p" ./.gitignore)
    local choices=$(printf "%s\n" $paths | fzf --multi --reverse --cycle)

    local dir_choices=$(printf "%s\n" "$choices" | awk -F'/' '
    {
        if ($0 ~ /\/$/) {
            dirs[$1] = dirs[$1] (dirs[$1] ? "\n" : "") $0 "\n"
        }
    }
    END {
        first = 1
        for (dir in dirs) {
            if (!first){
                print ""
                first = 0
            }
            printf dirs[dir]
        }
    }')

    local current_dir_file_choices=$(printf "%s\n" "$choices" | awk -F'/' '
    {
        if ($0 !~ /\/$/) {
            if (NF == 1) {
                pwd_files = pwd_files (pwd_files ? "\n" : "") $0
            }
        }
    }
    END {
        if (pwd_files) {
            print pwd_files
            print ""
        }
    }')

    local deep_dir_file_choices=$(printf "%s\n" "$choices" | awk -F'/' '
    {
        if ($0 !~ /\/$/) {
            if (NF != 1) {
                deep_files[$1] = deep_files[$1] (deep_files[$1] ? "\n" : "") $0
            }
        }
    }
    END {
        first = 1
        for (dir in deep_files) {
            if (!first){
                print ""
                first = 0
            }
            printf deep_files[dir]
        }
    }')

    printf "%s\n" $current_dir_file_choices
    echo -e ""
    printf "%s\n" $dir_choices
    echo -e ""
    printf "%s\n" $deep_dir_file_choices

    # printf "%s\n" $gitignore_data
    if [[ ! -z $choices ]]; then
        printf "\n" >> ./.gitignore
        printf "!%s\n" $current_dir_file_choices >> ./.gitignore
        printf "\n" >> ./.gitignore
        printf "!%s\n" $dir_choices >> ./.gitignore
        printf "\n" >> ./.gitignore
        printf "!%s\n" $deep_dir_file_choices >> ./.gitignore
    # else
    #     rm ./.gitignore
    fi

}


main
