# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

GITSTATUS_LOG_LEVEL=DEBUG

# Set Config
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -e
zstyle :compinstall filename '/home/zero/.zshrc'

#Style
# autoload -Uz compinit
# autoload -Uz add-zsh-hook
# autoload -Uz vcs_info
# precmd () { vcs_info }
# _comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    '+r:|[._-]=* r:|=*' \
    '+l:|=*'
    zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
    zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
    zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

# Exports
export PYDEVD_DISABLE_FILE_VALIDATION=1
export ZSH="$HOME/.oh-my-zsh"
export TERMINAL="alacritty"
export SHELL="/usr/bin/zsh"
export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down'
export PAGER='less -FRX'
# export BAT_PAGER="less -FRX"
export PATH="/home/$USER/anaconda3/bin/:$PATH"
export PATH="/home/$USER/.local/bin:/home/zero/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"
export PATH="$HOME/.cargo/bin:$PATH"
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
eval $(dbus-launch)
export DBUS_SESSION_BUS_ADDRESS
export TF_ENABLE_ONEDNN_OPTS=0
export TF_CPP_MIN_LOG_LEVEL=3
export CUDA_HOME=/opt/cuda
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export PATH=$CUDA_HOME/bin:$PATH
export LESS="--use-color"
export GTK_THEME=Materia-dark-compact
export GTK2_RC_FILES=~/.gtkrc-2.0

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    z
)

# Source:
source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
source ~/powerlevel10k/powerlevel10k.zsh-theme

# PreExec-Funcitons:
function preexec(){
    if [[ "$1" == *"--help"* ]]; then
        help=$(eval "$1")
        if [ ! -z "$help" ]; then
            echo "$help" | less
        else
            echo "$help"
        fi
        return 0
    fi
}

function config_opener(){
    local config_path=$1
    local program=$2
    (alacritty -e zsh -c "tmux new-session -s '$program-config' -c $config_path '$program'" &) &>/dev/null
}

function nconfig(){
    config_opener "~/.config/nvim" "nvim"
}

function note(){
    config_opener "~/note/" "nvim"
}

function tls() {
    active_session="$(tmux list-sessions 2>/dev/null)"
    if [[ ${#active_session} -ne 0 ]]; then
        echo "$active_session"
    else
        echo "No Session !!!"
    fi
}

function quick_tmux_call() {
    if [[ $# -eq 0 || $1 == "--help" || $1 == "-h" ]]; then
        echo "-h, --help : Display this help message."
        echo "\$1 : Name of the tmux session."
        echo "\$2 : Path to the directory for the session."
        echo "\$3 : Optional program to start in the session."
    else
        local session_name="$1"
        local dir_path="$2"
        local program="${3:-}"
        # Validate session name and directory path
        if [[ -z "$session_name" || -z "$dir_path" ]]; then
            echo "Error: Both session name and directory path are required."
            return 1
        fi
        # Check if session already exists
        if tmux has-session -t "$session_name" 2>/dev/null; then
            echo "Attaching to existing session '$session_name'."
            # Attach to the session
            tmux attach-session -t "$session_name"
        else
            # Create a new session in detached mode
            tmux -u new -s "$session_name" -c "$dir_path" "$program -c 'cd $dir_path'"
       fi
    fi
}


function keymap(){
    value=$(bindkey | fzf --ansi --reverse --preview="echo {} | awk '{print \$2}' ")
    if [ ! -z $value ]; then
        echo $value | awk '{print $2}' | xclip -selection clipboard
    fi
}

function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function compile(){
    local file_name=$1
    local output=$(echo $file_name | awk -F "." '{print $1}')
    gcc ${file_name} -o ${output}
}

function tt(){
    local wordlist=$1
    local num=$2
    if [[ "$num" =~ ^[0-9]+ ]]; then
        if [[ "$wordlist" =~ ^[0-9]+ ]]; then
            toipe -w top${wordlist} -n ${num}
        elif [[ "$wordlist" == "cms" ]]; then
            toipe -w commonly-misspelled -n ${num}
        else
            toipe -w ${wordlist} -n ${num}
        fi
    else
        echo "Invalid 2nd parameter."
    fi
}

# Alias:
alias pp="shotwell *"
alias ls="eza --icons --group-directories-first -l --hyperlink"
alias lss="eza --icons --group-directories-first -l --hyperlink --total-size"
alias :q="exit"
alias lsg="lsa | grep"
alias cht="bash ~/.config/LSD/cht.sh"
alias asdf="~/.config/LSD/exit.sh && exit"
alias cd="z"
alias cat="bat"
alias aic="ascii-image-converter"
alias trl="trash-list"
alias tre="trash-empty"
alias trp="trash-put"
alias trr="trash-restore"
# alias trm="trash-rm"
alias rm="trash"
alias vi="nvim"
alias ff="fastfetch"
alias ani="ani-cli"
alias lg="lazygit"
alias emoji="rofi -show emoji"
alias calc="rofi -show calc"
alias j2p="/usr/bin/env bash ~/.config/LSD/jpg_to_png.sh"
alias cdh="cd ~"
alias p3="python3"
alias cc="clear"
alias ee="exit"
alias lsf="/usr/bin/ls | fzf"
alias mp="mypy"
alias pd="bash ~/.config/LSD/fzf_pydocs.sh"
alias update-pydoc-list="python3 -u /home/zero/.config/LSD/update_pydocs.py"
alias bb="btop --utf-force"
alias srm="nvim ~/.config/LSD/.harpoon_on_steroids_data.txt"
alias tmuxall="sh ~/.config/LSD/harpoon_on_steroids.sh tmuxall"
alias tmuxselect="sh ~/.config/LSD/harpoon_on_steroids.sh tmuxselect"
alias tmuxkill="sh ~/.config/LSD/harpoon_on_steroids.sh killselect"
alias tmuxkillall="sh ~/.config/LSD/harpoon_on_steroids.sh killall"
alias td="tmux detach"
alias df="df -Ph"
alias hnctl="hostnamectl"
alias tree="tree | less"
alias cp="cp -i"
alias mvb="mv --backup"
alias fc-list="fc-list | fzf --reverse --multi"
alias du="du -h"
alias cp30k="~/.config/LSD/color.sh"
alias fzf="fzf --cycle --wrap --multi --reverse"
alias gitacp="bash ~/.config/LSD/gitacp.sh"

# Bindkey:
bindkey '^ ' autosuggest-accept
bindkey -s '^[f' "yy^M"
bindkey -s '^[c' "ndir=\`fzf --walker=dir,hidden --walker-root=/\` && cd \$ndir^M"
bindkey -s '^[g' "bash ~/.config/LSD/gitacp.sh^M"
bindkey -s '^[a' "bash ~/.config/LSD/harpoon_on_steroids.sh add^M"
bindkey -s '^[w' "bash ~/.config/LSD/harpoon_on_steroids.sh gotoW^M"
bindkey -s '^[s' "bash ~/.config/LSD/harpoon_on_steroids.sh gotoS^M"
bindkey -s '^[d' "bash ~/.config/LSD/harpoon_on_steroids.sh deleteline^M"
bindkey -s '^[k' "bash ~/.config/LSD/harpoon_on_steroids.sh killselect^M"
bindkey -s '^[C' "bash ~/.config/LSD/harpoon_on_steroids.sh killall^M"
# bindkey -s '^[h' "bash ~/.config/LSD/cht.sh^M"
# bindkey -s '^[m' "bash ~/.config/LSD/cht.sh man^M"
# bindkey -s '^[a' "ddgr^M"
bindkey -s '^g' "lazygit^M"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down
# bindkey -s '^[b' "btop --utf-force^M"
bindkey -r "^A"
# bindkey "\eI" beginning-of-line
# bindkey "\eA" end-of-line
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^h" backward-word
bindkey "^l" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

# >>> conda initialize >>>
__conda_setup="$('/home/zero/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/zero/anaconda3/etc/profile.d/conda.sh" ]; then
        # . "/home/zero/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
        # export PATH="/home/zero/anaconda3/bin:$PATH"  # commented out by conda initialize
    fi
fi
unset __conda_setup

# Yazi Config:
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Zoxide
eval "$(zoxide init zsh)"

eval $(thefuck --alias)
# export PATH="/home/zero/anaconda3/bin:$PATH" 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

