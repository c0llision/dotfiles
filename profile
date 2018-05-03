#!/bin/bash
#####################################################
# c0llision's bash profile
# https://github.com/c0llision/dotfiles
#####################################################
export TERM="xterm-color"                           # ensure colors work correctly
aliases_file="$HOME/.aliases"                       # bash aliases file

if [ -f $aliases_file ]; then
. $aliases_file                                     # Load aliases file
fi


#####################################################
# Path
#####################################################
function add_to_path()
{
    if is_dir $1; then
        export PATH="$1:$PATH"
    else
        echo "unable to add to path $1"
    fi
}
export CDPATH=":$code_dir:~:.."                     # change cdpath
add_to_path "$HOME/.cargo/bin"                      # rust cargo
add_to_path "$HOME/scripts"                         # My scripts
add_to_path "/usr/local/sbin"                       # brew(?)
add_to_path "/usr/local/opt/curl/bin"               # Newer curl
add_to_path /usr/local/opt/coreutils/libexec/gnubin # Use newer gnu coreutils from brew
# Go path
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
add_to_path "$GOPATH/bin"
add_to_path "$GOROOT/bin"


#####################################################
# General
#####################################################
shopt -s autocd                                     # cd into directory without typing cd
if is_app vim; then
  export EDITOR=vim                                 # make vim the default editor
  export VISUAL=vim
fi

if is_app sshuttle; then
  vpn() { sshuttle --dns -r $1 0/0;}                # Use sshuttle as an ssh VPN
fi

# Uncompress the file passed as an argument (thanks stackoverflow)
function extract () {
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


#####################################################
# Bash history
#####################################################
export HISTCONTROL="erasedups:ignoreboth"
export HISTFILESIZE=500000
export HISTSIZE=100000
#export HISTIGNORE="&:ls:[bf]g:exit:ZZ:pwd:clear:cl:?:??:[ \t]*"
export HISTIGNORE=""
shopt -s histappend
shopt -s cmdhist


#####################################################
# Prompt
#####################################################
function color_my_prompt {
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
# PS1='\[\033[1m\033[32m\]\u@\h \w\[\033[0m\]\$ '   # original PS1
color_my_prompt



#####################################################
# auto complete
# seriously broken
#####################################################
# Copied from: https://superuser.com/a/437508
# Automatically add completion for all aliases to commands having completion functions
function alias_completion {
    local namespace="alias_completion"

    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0

    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

    local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"

    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

        # skip aliases to pipes, boolean control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
        # avoid expanding wildcards
        read -a alias_arg_words <<< "$alias_args"

        # skip alias if there is no completion function triggered by the aliased command
        if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
            if [[ -n "$completion_loader" ]]; then
                # force loading of completions for the aliased command
                eval "$completion_loader $alias_cmd"
                # 124 means completion loader was successful
                [[ $? -eq 124 ]] || continue
                completions+=($alias_cmd)
            else
                continue
            fi
        fi
        local new_completion="$(complete -p "$alias_cmd")"

        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        (( COMP_POINT -= \${#COMP_LINE} ))
                        COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
                        (( COMP_POINT += \${#COMP_LINE} ))
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi

        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    source "$tmp_file" && rm -f "$tmp_file"
};

alias_completion
