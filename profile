#!/bin/bash
export TERM="xterm-color" 
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

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

# Bash history
export HISTCONTROL="erasedups:ignoreboth"
export HISTFILESIZE=500000
export HISTSIZE=100000
export HISTIGNORE="&:ls:[bf]g:exit:ZZ:pwd:clear:cl:?:??:[ \t]*"
shopt -s histappend
shopt -s cmdhist

function color_my_prompt {
    local __user_and_host="\[\033[01;32m\]\u@\h"
    local __cur_location="\[\033[01;34m\]\w"
    local __git_branch_color="\[\033[31m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __last_color="\[\033[00m\]"
    export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color$ "
}

color_my_prompt

# original PS1
# PS1='\[\033[1m\033[32m\]\u@\h \w\[\033[0m\]\$ '

shopt -s autocd
