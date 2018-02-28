#!/bin/bash
export TERM="xterm-color" 
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
if [ -x "$(command -v vim)" ]; then
  export EDITOR=vim
  export VISUAL=vim 
fi

# sshuttle
if [ -x "$(command -v sshuttle)" ]; then
  vpn() { sshuttle --dns -r $1 0/0;}
fi

# aliases
if [ -f ~/.aliases ]; then
. ~/.aliases
fi

# Fuck command
if [ -x "$(command -v thefuck)" ]; then
  eval $(thefuck --alias)
fi

# OSX only
if [[ "$OSTYPE" == "darwin"* ]]; then

  # SSH autocomplete
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
  fi
fi

function color_my_prompt {
    local __user_and_host="\[\033[01;32m\]\u@\h"
    local __cur_location="\[\033[01;34m\]\w"
    local __git_branch_color="\[\033[31m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __last_color="\[\033[00m\]"
    export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color$ "
}

#PS1='\[\033[1m\033[32m\]\u@\h \w\[\033[0m\]\$ ' # original PS1

color_my_prompt
shopt -s autocd
