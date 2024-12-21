result=$(cat ~/.config/LSD/.cht_language_list.txt | fzf --reverse --print-query)
search=$(echo "$result" | head -n 1)
selected=$(echo "$result" | tail -n 1)

if [ ! -z $search ] || [ ! -z $selected ]; then
    if [[ "$search" == */ ]] || [[ "$selected" == */ ]]; then
        read -p "query: " query
    fi

    if [ ! -z "$query" ]; then
        curl cht.sh/$selected`echo $query | tr ' ' '+'` | less
    else
        if [[ "$1" == "man" ]]; then
            man ${selected}
        else
            curl cht.sh/${selected%/} | bat
        fi
    fi
fi
