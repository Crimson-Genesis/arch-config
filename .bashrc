#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export GTK_THEME=Materia-dark-compact
export GTK2_RC_FILES=~/.gtkrc-2.0
