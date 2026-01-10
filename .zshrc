function config(){
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    # POWERLEVEL9K_INSTANT_PROMPT=off
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    GITSTATUS_LOG_LEVEL=DEBUG

    # Set Config:
    HISTFILE=~/.histfile
    HISTSIZE=10000
    SAVEHIST=10000
    setopt autocd extendedglob notify
    unsetopt beep nomatch
    bindkey -e
    zstyle :compinstall filename '/home/zero/.zshrc'

    # Exports:
    export PYDEVD_DISABLE_FILE_VALIDATION=1
    export ZSH="$HOME/.oh-my-zsh"
    export TERMINAL="alacritty"
    export SHELL="/usr/bin/zsh"
    export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down'
    export PAGER='less -FRX'
    export PATH="/home/$USER/anaconda3/bin:/home/$USER/.local/bin:/home/zero/.local/share/gem/ruby/3.0.0/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export GTK_IM_MODULE=ibus
    export QT_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus

    # Only start a dbus session if none exists (avoid duplication on each shell)
    if [[ -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    # On systems where systemd user DBus exists this is unnecessary; check before starting.
      if command -v dbus-launch >/dev/null 2>&1; then
        eval "$(dbus-launch --sh-syntax)" 2>/dev/null || true
        export DBUS_SESSION_BUS_ADDRESS
      fi
    fi
    # eval $(dbus-launch)

    export DBUS_SESSION_BUS_ADDRESS
    export TF_ENABLE_ONEDNN_OPTS=0
    export TF_CPP_MIN_LOG_LEVEL=3
    export CUDA_HOME=/opt/cuda
    export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
    export PATH=$CUDA_HOME/bin:$PATH
    export LESS="--use-color"
    export GTK_THEME=Materia-dark-compact
    export GTK2_RC_FILES=~/.gtkrc-2.0
    export CONDA_DEFAULT_ENV="base"
    # export BAT_PAGER="less -FRX"
    # export WINEPREFIX=~/.wine64
    # export WINEARCH=win64 winecfg
    # export DXVK_LOG_LEVEL=info
    # export QT_QPA_PLATFORM=xcb
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1  # Disable extra borders in some apps
    export QT_QPA_ENABLE_PLATFORMAUXBUFFERS=1     # Fix rendering issues in some cases
    export PATH=$JAVA_HOME/bin:$PATH
    export JAVA_HOME=/usr/lib/jvm/java-24-openjdk
    export KDEWallet=disabled
    export OPENMC_CROSS_SECTIONS=/run/media/nico/nova/Lab/Python/nuclear_sim/endfb71/endfb-vii.1-hdf5/cross_sections.xml
    export OMP_NUM_THREADS=4

    export WINEARCH=win64
    export WINEPREFIX=$HOME/.wine-silksong

    #Style:
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

    plugins=(
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
        z
        # zsh-vi-mode
    )

    # Source:
    source $ZSH/oh-my-zsh.sh
    source ~/powerlevel10k/powerlevel10k.zsh-theme

    # Lazy-load fzf completions/keybindings
    # if command -v fzf >/dev/null 2>&1; then
    #   _fzf_loaded=0
    #   _load_fzf() {
    #     if (( _fzf_loaded == 0 )); then
    #       # try both forms; some fzf versions use --completion, older ones use --zsh
    #       source <(fzf --completion 2>/dev/null) 2>/dev/null || source <(fzf --zsh 2>/dev/null) 2>/dev/null || true
    #       _fzf_loaded=1
    #     fi
    #   }
    #   # Trigger loader when fzf called or when completion system asks for it
    #   function fzf() { _load_fzf; command fzf "$@"; }
    #   # lazy completion: call loader on first completion attempt for fzf
    #   compdef _load_fzf fzf 2>/dev/null || true
    # fi
    source <(fzf --zsh)

    # Lazy-load zoxide
    if command -v zoxide >/dev/null 2>&1; then
      _zoxide_loaded=0
      _load_zoxide() {
        if (( _zoxide_loaded == 0 )); then
          eval "$(zoxide init zsh)" 2>/dev/null || true
          _zoxide_loaded=1
        fi
      }
      # Wrap the most common entry points (z and zoxide)
      function z() { _load_zoxide; command z "$@"; }
      function zoxide() { _load_zoxide; command zoxide "$@"; }
    fi


    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

}

function zsh_alias(){
# Alias:
    # Programs-alias:
        alias hyprland="start-hyprland"
        # eza:
        alias ls="eza --icons --group-directories-first -l --hyperlink"
        alias lss="eza --icons --group-directories-first -l --hyperlink --total-size"

        # trash-cli
        alias trl="trash-list"
        alias tre="trash-empty"
        alias trp="trash-put"
        alias trr="trash-restore"
        alias rm="trash"
        alias opython="/usr/bin/python3"
        # alias trm="trash-rm"

        # Alias-Alias
        alias lsg="lsa | grep"

        # Scripts
        alias cht="bash ~/.config/LSD/cht.sh"
        alias asdf="~/.config/LSD/exit.sh && exit"
        alias pd="bash ~/.config/LSD/fzf_pydocs.sh"
        alias update-pydoc-list="python3 -u /home/zero/.config/LSD/update_pydocs.py"
        alias srm="nvim ~/.config/LSD/.harpoon_on_steroids_data.txt"
        alias tmuxall="sh ~/.config/LSD/harpoon_on_steroids.sh tmuxall"
        alias tmuxselect="sh ~/.config/LSD/harpoon_on_steroids.sh tmuxselect"
        alias tmuxkill="sh ~/.config/LSD/harpoon_on_steroids.sh killselect"
        alias tmuxkillall="sh ~/.config/LSD/harpoon_on_steroids.sh killall"
        alias cp30k="~/.config/LSD/color.sh"
        alias gitacp="bash ~/.config/LSD/gitacp.sh"
        alias j2p="/usr/bin/env bash ~/.config/LSD/jpg_to_png.sh"
        alias tmux-save="~/.config/tmux/scripts/tmux_resurrect_helper.sh save"
        alias tmux-restore="~/.config/tmux/scripts/tmux_resurrect_helper.sh restore"
        alias yt_dlq="~/.config/LSD/yt_dlq.sh"

        # Other:
            # shortcuts:
            alias :q="exit"
            alias ee="exit"
            alias pp="shotwell *"
            # alias cd="z"
            alias aic="ascii-image-converter"
            alias vi="nvim"
            alias ff="fastfetch"
            alias ani="ani-cli"
            alias lg="lazygit"
            alias p3="python3"
            alias cc="clear"
            alias cdh="cd ~"
            alias lsf="/usr/bin/ls | fzf"
            alias bb="btop --utf-force"
            alias td="tmux detach"
            alias hnctl="hostnamectl"
            alias lsl="ls | bat"
            alias enter="distrobox enter"

            # flags or replacement:
            alias cat="bat"
            alias emoji="rofi -show emoji"
            alias calc="rofi -show calc"
            alias mvb="mv --backup"
            alias fc-list="fc-list | fzf --reverse --multi"
            alias fzf="fzf --cycle --wrap --multi --reverse"
            alias df="df -Ph"
            alias cp="cp -i"
            alias du="du -h"
            alias tree="tree | less"
}

function zsh_key_bingings(){
# Bindkey:
    # LSD
        # Harpoon for terminal:
        bindkey -s '^[a' "bash ~/.config/LSD/harpoon_on_steroids.sh add^M"
        bindkey -s '^[w' "bash ~/.config/LSD/harpoon_on_steroids.sh gotoW^M"
        bindkey -s '^[s' "bash ~/.config/LSD/harpoon_on_steroids.sh tmuxselect^M"
        bindkey -s '^[d' "bash ~/.config/LSD/harpoon_on_steroids.sh deleteline^M"
        bindkey -s '^[k' "bash ~/.config/LSD/harpoon_on_steroids.sh killselect^M"
        bindkey -s '^[C' "bash ~/.config/LSD/harpoon_on_steroids.sh killall^M"
        bindkey -s '^[g' "bash ~/.config/LSD/gitacp.sh^M"
        bindkey -s '^[i' "archwiki-offline -o w3m -m 'fzf --wrap --cycle --ansi --reverse'^M"

    # fzf:
    bindkey -s '^[c' "ndir=\`fzf --walker=dir,hidden --walker-root=/\` && cd \$ndir^M"

    # git:
    bindkey -s '^g' "lazygit^M"

    # other:
    bindkey -r "^A"
    bindkey -s '^[f' "yy^M"
    bindkey '^ ' autosuggest-accept
    bindkey "^a" beginning-of-line
    bindkey "^e" end-of-line
    bindkey "^h" backward-word
    bindkey "^l" forward-word
    bindkey "^[[1;3D" backward-word
    bindkey "^[[1;3C" forward-word
    # bindkey -s '^[b' "btop --utf-force^M"
    # bindkey "\eI" beginning-of-line
    # bindkey "\eA" end-of-line
    # bindkey -s '^[h' "bash ~/.config/LSD/cht.sh^M"
    # bindkey -s '^[m' "bash ~/.config/LSD/cht.sh man^M"
    # bindkey -s '^[a' "ddgr^M"
}

# # PreExec-Funcitons:
# function preexec() {
#     if [[ "$1" == *"--help"* ]]; then
#         com=${1%% --help*}
#         $com --help | less || echo "no help available for $1"
#         return 0
#     fi
# }

# zmodload zsh/zprof

config $@
zsh_alias
zsh_key_bingings

source ~/.config/zsh-scripts/.zsh_functions

if [[ ! -z $TMUX ]]; then
    activate_conda
fi

# # Lazy-load NVM
# export NVM_DIR="$HOME/.nvm"
#
# __nvmlazy() {
#   # Remove stubs
#   unset -f nvm node npm npx
#   # Load actual nvm if present
#   if [ -s "$NVM_DIR/nvm.sh" ]; then
#     . "$NVM_DIR/nvm.sh"
#   fi
#   if [ -s "$NVM_DIR/bash_completion" ]; then
#     . "$NVM_DIR/bash_completion"
#   fi
#   # Forward command to the real binary/function
#   if (( $# )); then
#     command "$@"
#   fi
# }
#
# # Create tiny stubs that call loader on first use
# for cmd in nvm node npm npx; do
#   eval "function $cmd() { __nvmlazy \"$cmd\" \"\$@\"; }"
# done
