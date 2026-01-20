#!/usr/bin/bash

data_file_path=~/.config/LSD/.harpoon_on_steroids_data.txt

fzf_path_highlight() {
    local values=("$@")
    while ifs= read -r line; do
        if [[ " ${values[*]} " == *" $line "* ]]; then
            echo -e "\e[1;32m$line\e[0m"
        else
            echo -e "$line"
        fi
    done
}

get_active_fzf_session(){
    local active_session=()
    while IFS= read -r session; do
        header=$(tmux show-option -t "$session" -qv @header)
        active_session+=("$header")
    done < <(tmux list-sessions -F '#S' 2>/dev/null)
    readarray -t data <<< "$active_session"
    echo -e "${active_session[@]}"
}

# build_fzf_dirs_cache() {
#     local cache="$HOME/.cache/fzf_dirs.cache"
#     local src="$data_file_path"
#
#     mkdir -p "${cache%/*}"
#
#     echo "[fzf-dirs] building cache..." >&2
#
#     sort -u "$src" | awk '
#     {
#         for (i = 1; i <= n; i++)
#             if ($0 ~ "^" roots[i] "/") next
#         roots[++n] = $0
#         print
#     }' | while IFS= read -r root; do
#         [[ -d "$root" ]] || continue
#         echo "[fzf-dirs] scanning: $root" >&2
#         find "$root" -type d 2>/dev/null
#     done > "$cache"
#
#     echo "[fzf-dirs] cache built at $cache" >&2
# }
#
# get_all_dirs_from_data_file() {
#     local cache="$HOME/.cache/fzf_dirs.cache"
#
#     if [[ ! -f "$cache" ]]; then
#         build_fzf_dirs_cache
#     fi
#
#     cat "$cache"
# }
#
#
#
# fzf_select() {
#     local active_paths
#     mapfile -t active_paths < <(get_active_fzf_session)
#
#     local input
#     input="$(get_all_dirs_from_data_file | fzf_path_highlight "${active_paths[@]}")"
#
#     if [[ $# -ne 0 ]]; then
#         fzf --wrap --cycle --ansi --reverse \
#             --preview "echo 'Session name :-'; echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'" \
#             --header="$1" <<< "$input"
#     else
#         fzf --wrap --cycle --ansi --reverse \
#             --preview "echo 'Session name :-'; echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'" \
#             <<< "$input"
#     fi
# }
#
# fzf_multi_select() {
#     local active_paths
#     mapfile -t active_paths < <(get_active_fzf_session)
#
#     local input
#     input="$(get_all_dirs_from_data_file | fzf_path_highlight "${active_paths[@]}")"
#
#     if [[ $# -ne 0 ]]; then
#         fzf --wrap --cycle --ansi --reverse -m \
#             --preview "echo 'Session name :-'; echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'" \
#             --header="$1" <<< "$input"
#     else
#         fzf --wrap --cycle --ansi --reverse -m \
#             --preview "echo 'Session name :-'; echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'" \
#             <<< "$input"
#     fi
# }

fzf_multi_select(){
    local active_paths=($(get_active_fzf_session))
    if [[ $# -ne 0 ]]; then
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --wrap --cycle --ansi --reverse --preview \
            "echo 'Session name :-' && echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'" -m --header="$1")
    else
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --wrap --cycle --ansi --reverse --preview \
            "echo 'Session name :-' && echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'" -m)
    fi
    readarray -t choices_array <<< "$choices"
    echo -e "${choices[@]}"
}

fzf_select(){
    local active_paths=($(get_active_fzf_session))
    if [[ $# -ne 0 ]]; then
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --wrap --cycle --ansi --reverse --preview \
            "echo 'Session name :-' && echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'" --header="$1")
    else
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --wrap --cycle --ansi --reverse --preview \
            "echo 'Session name :-' && echo {} | awk -F '/' '{print \$(NF-1)\"-\"\$NF}' | tr '.' '_'")
    fi
    echo -e "$choices"
}

create_session_and_window(){
    local session_name=$1
    local session_path=$2
    local session_program=$3

    tmux -u new -s "$session_name" -c "$session_path" -d "tmux set-option -t $session_name @header '$session_path' && $session_program"
    tmux -u new-window -t "$session_name" -n "Terminal" -c "$session_path" -d
}

new_session_attach() {
    create_session_and_window $@ "exec zsh"
    tmux -u attach-session -t "$1"
}

new_session_switch() {
    create_session_and_window $@ "exec zsh"
    tmux -u switch-client -t "$1"
}

nvim_new_session_attach() {
    create_session_and_window $@ "nvim"
    tmux -u attach-session -t "$session_name"
    tmux set-option -t $1 @header "$2"
}

nvim_new_session_switch() {
    create_session_and_window $@ "nvim"
    tmux -u switch-client -t "$1"
    tmux set-option -t $1 @header "$2"
}

case "$1"
in
    add)
        if grep -Fxq "$(pwd)" "$data_file_path"; then
            echo -e "\033[38;5;1mAlready exists...\033[0m"
        else
            echo -e "$(pwd)" >> "$data_file_path"
            echo -e "\033[38;5;2mAdded: $(pwd) -> List...\033[0m"
        fi
        exit
        ;;

    gotoW)
        choices=($(fzf_multi_select "Create Tmux Windows"))
        choice_count=${#choices[@]}
        if [[ $choice_count -eq 1 ]]; then
            path=$choices
            if [ ! -z $path ]; then
                if [ ! -z $TMUX ]; then
                    tmux -u new-window -c "$path"
                else
                    echo -e "\033[38;5;1mNot In Tmux Session...\033[0m"
                    exit
                fi
            fi
        elif [[ $choice_count -gt 1 ]]; then
            echo -e "CREATE WINDOWS ?"
            for i in ${choices[@]}; do
                echo -e "\033[38;5;3m$i\033[0m"
            done
            read -p "Confirm(Y|n):- " confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
                for path in ${choices[@]}; do
                    tmux -u new-window -c "$path" -d
                    echo -e "\033[38;5;10mCreated window :- at $path\033[0m"
                done
                echo -e "\033[38;5;2mCREATION PROCESS COMPLETE...\033[0m"
            else
                echo -e "\033[38;5;1mCANCELING THE SESSION CREATION PROCESS...\033[0m"
            fi
        fi
        exit
        ;;

    tmuxselect)
        choices=($(fzf_multi_select "Create Tmux Sessions"))
        choice_count=${#choices[@]}
        if [[ $choice_count -eq 1 ]]; then
            dirname="$(echo $choices | awk -F '/' '{print $(NF-1)"-"$(NF)}' | tr "." "_")"
            if [ ! -z $choices ]; then
                tmux has-session -t "$dirname" > /dev/null 2>&1
                exitcode=$?
                if [ ! -z $TMUX ]; then
                    if [ 0 -eq $exitcode ]; then
                        tmux -u switch-client -t "$dirname"
                    else
                        new_session_switch $dirname $choices
                    fi
                else
                    if [ "nvim" == "$2" ]; then
                        if [ 0 -eq $exitcode ]; then
                            tmux -u attach-session -t "$dirname"
                        else
                            nvim_new_session_attach $dirname $choices
                        fi
                    else
                        if [ 0 -eq $exitcode ]; then
                            tmux -u attach-session -t "$dirname"
                        else
                            new_session_attach $dirname $choices
                        fi
                    fi
                fi
            fi
        elif [[ $choice_count -gt 1 ]]; then
            count=0
            echo -e "CREATE SESSIONS ?"
            for i in ${choices[@]}; do
                echo -e "\033[38;5;3m$i\033[0m"
            done
            read -p "Confirm(Y|n):- " confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
                for path in ${choices[@]}; do
                    dirname="$(awk -F '/' '{print $(NF-1)"-"$NF}' <<< $path | tr "." "_")"
                    tmux has-session -t "$dirname" > /dev/null 2>&1 
                    exitcode=$?
                    if [ 0 -eq $exitcode ]; then
                        echo -e "\033[38;5;6mAlready session :- $dirname at $path\033[0m"
                    else
                        create_session_and_window $dirname $path "exec zsh"
                        echo -e "\033[38;5;10mCreated session :- $dirname at $path\033[0m"
                        ((count++))
                    fi
                done
                if [ $count -eq 0 ]; then
                    echo -e "\033[38;5;1mNO SESSION CREATED...\033[0m"
                else
                    echo -e "\033[38;5;2mTOTAL $count SESSION CREATED...\033[0m"
                    echo -e "\033[38;5;2mCREATION PROCESS COMPLETE...\033[0m"
                fi
            else
                echo -e "\033[38;5;1mCANCELING THE SESSION CREATION PROCESS...\033[0m"
            fi
        fi
        exit
        ;;

    tmuxall)
        count=0
        mapfile -t data < "$data_file_path"
        for path in ${data[@]}; do
            dirname="$(awk -F '/' '{print $(NF-1)"-"$NF}' <<< $path | tr "." "_")"
            tmux has-session -t "$dirname" > /dev/null 2>&1
            exitcode=$?
            if [ 0 -eq $exitcode ]; then
                echo -e "\033[38;5;6mAlready session :- $dirname at $path\033[0m"
            else
                create_session_and_window $dirname $path "exec zsh"
                echo -e "\033[38;5;10mCreated session :- $dirname at $path\033[0m"
                ((count++))
            fi
        done
            if [ $count -eq 0 ]; then
                echo -e "\033[38;5;1mNO SESSION CREATED...\033[0m"
            else
                echo -e "\033[38;5;2mTOTAL $count SESSION CREATED...\033[0m"
                echo -e "\033[38;5;2mCREATION PROCESS COMPLETE...\033[0m"
            fi
        exit
        ;;

    deleteline)
        cp "$data_file_path" "${data_file_path}.bak"
        choice=($(fzf_multi_select "Delete a Line"))
        if [[ ${#choice[@]} -eq 0 ]]; then
            exit
        fi
        echo -e "Delete lines:"
        for i in ${choice[@]}; do
            echo -e "\033[38;5;3m$i\033[0m"
        done
        read -p "Confirm(Y|n):- " confirm
        if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
            line_numbers=()
            for selected_line in "${choice[@]}"; do
                line_number=$(grep -Fnx "$selected_line" "$data_file_path" | cut -d: -f1)
                if [[ -n $line_number ]]; then
                    line_numbers+=($line_number)
                fi
            done
            for line in $(printf "%s\n" "${line_numbers[@]}" | sort -nr); do
                sed -i "${line}d" "$data_file_path"
            done
            echo -e "\033[38;5;2mDELETION PROCESS COMPLETE...\033[0m"
        else
            echo -e "\033[38;5;1mCANCELING THE DELETE PROCESS...\033[0m"
        fi
        exit
        ;;

    killselect)
        count=0
        active_paths=($(get_active_fzf_session))
        choices=($(fzf_multi_select "Select to Kill:-"))
        if [[ ${#choices[@]} -ne 0 ]]; then
            echo -e "Selected Sessions:-"
            for i in ${choices[@]}; do
                echo -e "\033[38;5;3m$i\033[0m"
            done
            read -p "Confirm(Y|n):- " confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
                for path in ${choices[@]}; do
                    if [[ " ${active_paths[*]} " == *" $path "* ]]; then
                        dirname="$(awk -F '/' '{print $(NF-1)"-"$NF}' <<< $path | tr "." "_")"
                        tmux kill-session -t "$dirname"
                        echo -e "\033[38;5;10mKilled session :- $dirname at $path\033[0m"
                        ((count++))
                    else
                        echo -e "\033[38;5;1mNot a Session :- $dirname at $path\033[0m"
                    fi
                done
                if [ $count -eq 0 ]; then
                    echo -e "\033[38;5;1mNO SESSION KILLED...\033[0m"
                else
                    echo -e "\033[38;5;2mTOTAL $count SESSION KILLED...\033[0m"
                    echo -e "\033[38;5;2mKILLING PROCESS COMPLETE...\033[0m"
                fi
            else
                echo -e "\033[38;5;1mCANCELING THE KILLING PROCESS...\033[0m"
            fi
        fi
        exit
        ;;

    killall)
        active_session="$(tmux list-sessions 2>/dev/null)"
        if [[ ${#active_session} -ne 0 ]]; then
            echo -e "Active Sessions:-"
            echo -e "\033[38;5;3m$active_session\033[0m"
            read -p "Confirm(Y|n):- " confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
                tmux kill-session -a > /dev/null
                tmux kill-session > /dev/null
                echo -e "\033[38;5;2mKILLING PROCESS COMPLETE...\033[0m"
            else
                echo -e "\033[38;5;1mCANCELING THE KILLING PROCESS...\033[0m"
            fi
        else
            echo -e "\033[38;5;1mNo Active Sessions...\033[0m"
        fi
        exit
        ;;
    buildcatch)
        rm -f "$HOME/.cache/fzf_dirs.cache"
        build_fzf_dirs_cache
    ;;
    *)
        echo -e "\033[38;5;1mInvalid command...\033[0m"
        exit
esac
