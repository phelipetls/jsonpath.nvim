# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

export EDITOR=nvim

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Configure history
setopt histignorealldups sharehistory

HISTSIZE=50000
SAVEHIST=50000
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

# Place items under their group description
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

# Enable history search with up and down arrows
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Enable Ctrl+Left and Ctrl+Right
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Enable Ctrl-X + Ctrl-E to edit command in $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Add Shift+Tab to move through completion menu backwards
if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete
fi

alias r='ranger'

# Add default less options
# -F to quit automatically if the file is shorter than the screen
# -X to not clear the screen after quitting
# -R to show only color escape sequences in raw form
# -M to show a more verbose prompt
export LESS="FXRM"

# Add local scripts folder into PATH
export PATH="$HOME/scripts/:$PATH"

# Add Ubuntu snap related PATH
export PATH="/snap/bin:$PATH"

# Add LaTeX related PATH
export PATH="/usr/local/texlive/2019/bin/x86_64-linux/:$PATH"
export MANPATH="/usr/local/texlive/2019/texmf-dist/doc/man/:$MANPATH"
export INFOPATH="/usr/local/texlive/2019/texmf-dist/doc/info/:$INFOPATH"

# Add Android Studio related PATH
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"

export PATH="$HOME/android-studio/bin:$PATH"
export PATH="$ANDROID_SDK_ROOT/emulator:$PATH"
export PATH="$ANDROID_SDK_ROOT/tools:$PATH"
export PATH="$ANDROID_SDK_ROOT/tools/bin:$PATH"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

export _JAVA_AWT_WM_NONREPARENTING=1 # Needed for Android Studio to work in DWM

# Fix Intel graphics driver issue in Ubuntu 20.04
# https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1876219
export MESA_LOADER_DRIVER_OVERRIDE=i965

# Add npm related PATH
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="$MANPATH:$NPM_PACKAGES/share/man"

# Add n related variables
export N_PREFIX="$HOME/.local"

# Add Python related PATH
export PATH="$HOME/.poetry/bin:$PATH"

# Add Go related PATH
export GOPATH="$HOME/go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"

# Add Rust related PATH
export PATH="$HOME/.cargo/bin:$PATH"
