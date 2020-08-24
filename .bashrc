# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export EDITOR=nvim

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=$HISTSIZE
HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

function _get_venv {
  if [ $VIRTUAL_ENV ]; then
    printf '(%s) ' $(basename $VIRTUAL_ENV)
  fi
}

function _get_cwd {
  # shorten current pwd if on a small terminal
  if [[ $COLUMNS -gt 80 ]]; then
    echo -n '\w'
  else
    echo -n '\W'
  fi
}

function _dynamic_prompt() {
  export PS1="\
`_get_venv`\
\[\e[01;32m\]\u \
\[\e[01;33m\]@ \
\[\e[01;94m\]`_get_cwd` \
\[\e[01;90m\]\$ \
\[\e[m\]"
}

PROMPT_COMMAND=_dynamic_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# autocompletion
eval "$(pandoc --bash-completion)"
source ~/.tmux/tmux_bash_completion

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# less config
export LESS="FXRM"

# path
export PATH="/usr/local/texlive/2019/bin/x86_64-linux/:$PATH"
export MANPATH="/usr/local/texlive/2019/texmf-dist/doc/man/:$MANPATH"
export INFOPATH="/usr/local/texlive/2019/texmf-dist/doc/info/:$INFOPATH"

export PATH="$HOME/.scripts/:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export GOPATH="$HOME/go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"

export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/
