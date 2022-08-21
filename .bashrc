# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

source "$HOME/.profile"

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
if [ -x /usr/bin/lesspipe ]; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# source git file containing __git_ps1 function
if [ -f /usr/lib/git-core/git-sh-prompt ]; then
  source /usr/lib/git-core/git-sh-prompt
elif [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

export PS1='\
\[\e[1;32m\]\u \
\[\e[1;33m\]@ \
\[\e[1;94m\]\w \
\[\e[1;33m\]$(__git_ps1 "(%s) ")\
\[\e[1;32m\]$([ \j -gt 0 ] && echo "* ")\
\[\e[1;90m\]\$ \
\[\e[0m\]\
'

# this is useful to color tmux windows with "activity" differently, so it
# notifies me that something wrong happened in that window
beep_on_error() {
  if [[ $? -gt 0 ]]; then
    echo -ne '\a'
  fi
}

export PROMPT_COMMAND='beep_on_error'

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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

# configure tmux
if [ -f ~/.tmux/tmux_bash_completion ]; then
  source ~/.tmux/tmux_bash_completion
fi

# configure fzf
export PATH="$HOME/.fzf/bin:$PATH"
source "$HOME/.fzf/shell/completion.bash"
source "$HOME/.fzf/shell/key-bindings.bash"

export FZF_DEFAULT_COMMAND='rg --files --hidden --color=never'
export FZF_ALT_C_COMMAND='fd --color=never --type d'

_fzf_compgen_path() {
  rg --files --hidden --color=never
}

_fzf_compgen_dir() {
  fdfind --color=never --type d
}

_fzf_setup_completion path npm
