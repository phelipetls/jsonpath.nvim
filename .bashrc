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
HISTSIZE=50000
HISTFILESIZE=$HISTSIZE
HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:ls:l:ll:lll"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

[ -f /usr/lib/git-core/git-sh-prompt ] && source /usr/lib/git-core/git-sh-prompt

export PS1='\
\[\e[1;32m\]\u \
\[\e[1;33m\]@ \
\[\e[1;94m\]\w \
\[\e[1;33m\]$(__git_ps1 "(%s) ")\
\[\e[1;32m\]$([ \j -gt 0 ] && echo "* ")\
\[\e[1;90m\]\$ \
\[\e[0m\]\
'

beep_on_error() {
  if [[ $? -gt 0 ]]; then
    echo -ne '\a'
  fi
}

export PROMPT_COMMAND='beep_on_error'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto --group-directories-first'

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
[ -f ~/.tmux/tmux_bash_completion ] && source ~/.tmux/tmux_bash_completion

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --hidden --color=never'
export FZF_ALT_C_COMMAND='fdfind --color=never --type d'

_fzf_compgen_path() {
  rg --files --hidden --color=never
}

_fzf_compgen_dir() {
  fdfind --color=never --type d
}

_fzf_setup_completion path npm

export LESS="FXRM"

export _JAVA_AWT_WM_NONREPARENTING=1 # Needed for Android Studio to work in DWM

# Fix Intel graphics driver issue in Ubuntu 20.04
# https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1876219
export MESA_LOADER_DRIVER_OVERRIDE=i965

tmux() {
  systemd-run --scope --user tmux "$@"
}
