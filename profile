#!/bin/bash
#####################################################
# c0llision's bash profile
# https://github.com/c0llision/dotfiles
#####################################################
aliases_file="$HOME/.aliases"                       # bash aliases file
debug_mode=0


#####################################################
# Load alias file
#####################################################
if [ -f $aliases_file ]; then
. $aliases_file
fi


#####################################################
# Path
#####################################################
function add_to_path()
{
    if is_dir $1; then
        export PATH="$1:$PATH"
    elif [ "$debug_mode" -eq 1 ]; then
        echo "unable to add to path $1"
    fi
}
export CDPATH=".:$code_dir:~:.."                     # change cdpath
add_to_path "$HOME/scripts"                         # My scripts
add_to_path "/usr/local/sbin"                       # brew(?)
add_to_path "/usr/local/opt/curl/bin"               # Newer curl
add_to_path /usr/local/opt/coreutils/libexec/gnubin # Use newer gnu coreutils from brew
add_to_path $HOME/.tmuxifier/bin                    # tmuxifier
# Go path
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
add_to_path "$GOPATH/bin"
add_to_path "$GOROOT/bin"
# export PYTHONPATH="/usr/local/lib/python3.6/site-packages/foundation/"


#####################################################
# General
#####################################################
shopt -s autocd                                     # cd into directory without typing cd
export EDITOR=vim                                 # make vim the default editor
export VISUAL=vim

# OSX only
if [[ "$OSTYPE" == "darwin"* ]]; then
  # SSH autocomplete
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
  fi

  # terminal colors
  export TERM=xterm-256color
fi

if is_app tmuxifier; then
  eval "$(tmuxifier init -)"                        # Start tmuxifier
fi


#####################################################
# Bash history
#####################################################
export HISTCONTROL="erasedups:ignoreboth"
export HISTFILESIZE=500000
export HISTSIZE=100000
export HISTIGNORE="vp"
shopt -s histappend
shopt -s cmdhist


#####################################################
# GPG as SSH key
#####################################################
if is_app gpgconf; then
  gpgconf --launch gpg-agent
fi

export "GPG_TTY=$(tty)"
export "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh"
# export PINENTRY_USER_DATA="USE_CURSES=1"


#####################################################
# Prompt
#####################################################
function color_my_prompt {
    # PS1='\[\033[1m\033[32m\]\u@\h \w\[\033[0m\]\$ '   # original PS1
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        local __color="\[\033[01;31m\]" # red
     else
        local __color="\[\033[01;32m\]" # green
     fi

    if [ `whoami` == 'root' ]; then
        local __user_and_host="# \u@\h"
    else
        local __user_and_host="$ \h"
    fi

    local __cur_location="\[\033[01;34m\]\w"
    local __git_branch_color="\[\033[31m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __last_color="\[\033[00m\]"
    export PS1="$__color$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color> "
}
color_my_prompt

# Display blank line before output of command (this needs to be last in .profile)
trap 'echo' DEBUG

##
# Your previous /Users/c0llision/.profile file was backed up as /Users/c0llision/.profile.macports-saved_2018-06-16_at_09:39:27
##

# MacPorts Installer addition on 2018-06-16_at_09:39:27: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

