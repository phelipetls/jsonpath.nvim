# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# Configure completion. See https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Control-Functions
zstyle ':completion:*' completer _expand _complete _correct _approximate

# Match case insensitively
# Also match "c.s.u" with "comp.source.unix"
# See https://zsh.sourceforge.io/Doc/Release/Completion-Widgets.html#Completion-Matching-Control
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Do not group anything
zstyle ':completion:*' group-name ''

# Highlight currently selected item in completion list
zstyle ':completion:*' menu yes select

# Show these messages when completion list is too long
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Show description for items in completion list
zstyle ':completion:*' verbose true

# Color kill command output
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Colored ls output
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Do not use colors in other commands
zstyle ':completion:*' list-colors ''

# Some obscure setting I'm not removing
zstyle ':completion:*' use-compctl false
