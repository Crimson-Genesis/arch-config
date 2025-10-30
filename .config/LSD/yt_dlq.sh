#!/usr/bin/env bash
set -euo pipefail

function cecho(){
    local color_code=$1
    local message=$2
    # echo -e "\033[38;5;${color_code}m${message}\033[0m"
    printf '\033[38;5;%sm%s\033[0m\n' "${color_code}" "${message}"

}

if [[ -z "${1:-}" ]]; then
    cecho 1 "Usage: $0 [video|list|channel]"
    exit 1
fi

function main() {
  local link_type="$1"
  shift || true

  local youtube_link
  read -e -p "YouTube Link: " youtube_link
  [ -z "$youtube_link" ] && { echo "No URL provided."; return 1; }

  local namer
  case "$link_type" in
    video)   namer='%(title)s.%(ext)s' ;;
    list)    namer='%(uploader)s/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s' ;;
    channel) namer='%(uploader)s/%(upload_date>%Y-%m-%d)s - %(title)s.%(ext)s' ;;
    *)
      cecho 1 "Invalid type: use one of: video | list | channel"
      return 1
      ;;
  esac

  # parse flags (only -q supported here)
  local use_quiet_picker=0
  local arg
  for arg in "$@"; do
    case "$arg" in
      -q) use_quiet_picker=1 ;;
      *)  ;; # ignore unknown for now
    esac
  done

  local fmt=""
  local sel=""
  if [ "$use_quiet_picker" -eq 1 ]; then
    sel=$(
      yt-dlp --no-color --list-formats "$youtube_link" 2>&1 \
        | sed -n '/Available formats for/,$p' \
        | sed '1,2d' \
        | sed 's/\x1b\[[0-9;]*m//g' \
        | grep -E '^\s*(sb[0-9]+|[0-9]+(-[A-Za-z0-9]+)?)\b' \
        | fzf --no-hscroll --ansi --preview 'echo {}'
    )
    # If user cancelled fzf, sel will be empty; abort gracefully
    if [ -z "$sel" ]; then
      cecho 1 "Selection cancelled — aborting."
      return 1
    fi
    fmt=$(printf '%s' "$sel" | awk '{print $1}')
  else
    # default: best combined (video+audio)
    fmt="bestvideo+bestaudio"
  fi

  # If user explicitly selected a video-only id, append bestaudio (but avoid duplicates)
  if [ -n "$sel" ] && printf '%s\n' "$sel" | grep -qi 'video only'; then
    # only append if the selected fmt doesn't already include '+'
    if ! printf '%s' "$fmt" | grep -q '+'; then
      fmt="${fmt}+bestaudio"
    else
      # user selected an id like "299" but fmt contains something like "bestvideo+bestaudio"
      # in that case keep fmt as-is (user probably wants the selection)
      fmt="${fmt}"
    fi
  fi

  cecho 2 "Downloading → format: ${fmt}"
  yt-dlp -ciw -f "${fmt}" \
    -o "${namer}" \
    --merge-output-format mp4 \
    --download-archive archive.txt \
    "$youtube_link" || { echo "yt-dlp failed"; return 1; } \
    && cecho 2 "✅ Download completed!"
}

main $@
