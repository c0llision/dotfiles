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

# Uncompress the file passed as an argument (thanks stackoverflow)
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar        xvjf $1   ;;
           *.tar.gz)    tar        xvzf $1   ;;
           *.bz2)       bunzip2         $1   ;;
           *.rar)       unrar      x    $1   ;;
           *.gz)        gunzip          $1   ;;
           *.tar)       tar        xvf  $1   ;;
           *.tbz2)      tar        xvjf $1   ;;
           *.tgz)       tar        xvzf $1   ;;
           *.zip)       unzip           $1   ;;
           *.Z)         uncompress      $1   ;;
           *.7z)        7z         x    $1   ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}


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
