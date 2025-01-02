#!/usr/bin/env bash

main(){
    local dir_paths=$(find . -mindepth 1 -type d | sed "s/^..\(.*\)/\1\//g" | sort)
    local file_paths=$(find . -type f | sed "s/^..\(.*\)/\1/g" | sort)
    local paths=$(echo "$file_paths $dir_paths")
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

    local cwd_dir_file_choices=$(printf "%s\n" "$choices" | awk -F'/' '
    {
        if ($0 !~ /\/$/) {
            if (NF == 1) {
                pwd_files = pwd_files (pwd_files ? "\n" : "") $0 "\n"
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
                deep_files[$1] = deep_files[$1] (deep_files[$1] ? "\n" : "") $0 "\n"
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

    local gitignore_file_path="$1"
    local current_gitignore_file_path="./$gitignore_file_path"
    local gitignore_backup_file_path="./$gitignore_file_path.bak"
    local gitignore_data=$(sed -n "2,\$s/^.\(.*\)/\1/p" $current_gitignore_file_path)

    if [[ ! -z $choices ]]; then
        if [ -s $gitignore_file_path ];then
            cp ${current_gitignore_file_path} ${gitignore_backup_file_path}
            echo "*" > ${current_gitignore_file_path}
        else
            echo "*" > ${current_gitignore_file_path}
        fi

        printf "\n" >> ${current_gitignore_file_path}
        if [[ ! -z  $cwd_dir_file_choices ]]; then
            printf "!%s\n" $cwd_dir_file_choices >> ${current_gitignore_file_path}
            printf "\n" >> ${current_gitignore_file_path}
        fi

        if [[ ! -z $dir_choices ]]; then
            for word in $dir_choices; do
                previous=""
                for per_word in $(echo $word | tr '/' ' '); do
                    if [[ ! -z $previous ]]; then
                        previous="$previous/$per_word/"
                        printf "!$previous\n" >> ${current_gitignore_file_path}
                    else
                        previous="$per_word"
                        printf "!$previous/\n" >> ${current_gitignore_file_path}
                    fi
                done
                printf "!$word**/*\n" >> ${current_gitignore_file_path}
                printf "\n" >> ${current_gitignore_file_path}
            done
        fi

        if [[ ! -z $deep_dir_file_choices ]]; then
            for word in $deep_dir_file_choices; do
                previous=""
                path_depth=$(echo $word | awk -F "/" "{print NF}")
                echo "path:- $path_depth"
                for per_word in $(echo $word | tr '/' ' '); do
                    if [[ ! -z $previous ]]; then
                        if (( $path_depth > 1 )); then
                            previous="$previous$per_word/"
                        else
                            previous="$previous$per_word"
                        fi
                    else
                        previous="$per_word/"
                    fi
                    printf "!$previous\n" >> ${current_gitignore_file_path}
                    ((path_depth--))
                done
                printf "\n" >> ${current_gitignore_file_path}
            done
        fi
    # else
    #     rm ./.gitignore
    fi

}

fucntion check_line(){
    
}

main $1
