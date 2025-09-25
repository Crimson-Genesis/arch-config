#!/usr/bin/env bash
if [[ -z "$1" ]]; then
    echo "Usage: $0 [video|list|channel]"
    exit 1
fi

function cecho(){
    local color_code=$1
    local message=$2
    echo -e "\033[38;5;${color_code}m${message}\033[0m"
}

function main(){
    link_type=$1
    read -e -p "YouTube Link: " youtube_link

    case "$link_type" in
        video)
            cecho 2 "Downloading Video - ${youtube_link}"
            yt-dlp -ciw -f bestvideo+bestaudio \
                -o "%(title)s.%(ext)s" \
                --merge-output-format mp4 \
                --download-archive archive.txt \
                "$youtube_link"
            ;;
        list)
            cecho 2 "Downloading Playlist - ${youtube_link}"
            yt-dlp -ciw -f bestvideo+bestaudio \
                -o "%(uploader)s/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" \
                --merge-output-format mp4 \
                --download-archive archive.txt \
                "$youtube_link"
            ;;
        channel)
            cecho 2 "Downloading Channel - ${youtube_link}"
            yt-dlp -c -f bestvideo+bestaudio \
                -o "%(uploader)s/%(upload_date>%Y-%m-%d)s - %(title)s.%(ext)s" \
                --merge-output-format mp4 \
                --download-archive archive.txt \
                "$youtube_link"
            ;;
        *)
            cecho 1 "Invalid type: use video | list | channel"
            exit 1
            ;;
    esac
    cecho 2 "✅ Download completed!"
}

main "$1"

