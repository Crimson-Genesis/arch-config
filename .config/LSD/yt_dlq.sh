#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    exit
fi

function cecho(){
    local color_code=$1
    local message=$2
    echo -e "\033[38;5;${color_code}m${message}\033[0m"
}

function main(){
    link_type=$1
    read -e -p "Youtube Link:- " youtube_link

    if [[ $link_type == "list" ]]; then
        cecho 2 "Starting the download of Playlist ${youtube_link}"
        yt-dlp -f bestvideo+bestaudio -o '%(playlist_index)s - %(title)s.%(ext)s' --merge-output-format mp4 ${youtube_link}
        cecho 2 "Download completed..."
    elif [[ $link_type == "video" ]]; then
        cecho 2 "Starting the download of Video ${youtube_link}"
        yt-dlp -f bestvideo+bestaudio -o '%(title)s.%(ext)s' --merge-output-format mp4 ${youtube_link}
        cecho 2 "Download completed..."
    else
        cecho 1 "Invalid download type..."
    fi
}

main $1 $2
