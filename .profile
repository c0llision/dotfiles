export TERM="xterm-color" 
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# aliases
if [ -f ~/.aliases ]; then
. ~/.aliases
fi

# Fuck command
eval $(thefuck --alias)

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
    #local __git_branch="\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')\"\`"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __prompt_tail="" #"\[\033[35m\]$"
    local __last_color="\[\033[00m\]"
    export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color$ "
}
#PS1='\[\033[1m\033[32m\]\u@\h \w\[\033[0m\]\$ '

color_my_prompt
shopt -s autocd

