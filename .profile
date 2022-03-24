# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Add local scripts folder into PATH
if [ -d "$HOME/scripts" ]; then
  export PATH="$HOME/scripts/:$PATH"
fi

# Add Ubuntu snap related PATH
if [ -d "/snap/bin" ]; then
  export PATH="/snap/bin:$PATH"
fi

# Add LaTeX related PATH
if [ -d "/usr/local/texlive" ]; then
  export PATH="/usr/local/texlive/2019/bin/x86_64-linux/:$PATH"
  export MANPATH="/usr/local/texlive/2019/texmf-dist/doc/man/:$MANPATH"
  export INFOPATH="/usr/local/texlive/2019/texmf-dist/doc/info/:$INFOPATH"
fi

# Add Android SDK related PATH
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
if [ -d "$ANDROID_SDK_ROOT" ]; then
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
  export PATH="$ANDROID_SDK_ROOT/emulator:$PATH"
  export PATH="$ANDROID_SDK_ROOT/tools:$PATH"
  export PATH="$ANDROID_SDK_ROOT/tools/bin:$PATH"
  export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"
fi

# Add Android SDK related PATH
if [ -d "$HOME/android-studio/bin" ]; then
  export PATH="$HOME/android-studio/bin:$PATH"
fi

if [ -f "/usr/lib/jvm/java-11-openjdk-amd64" ]; then
  export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
fi

# Add npm related PATH
NPM_PACKAGES="$HOME/.npm-packages"

if [ -d "$NPM_PACKAGES" ]; then
  export PATH="$PATH:$NPM_PACKAGES/bin"
  export MANPATH="$MANPATH:$NPM_PACKAGES/share/man"
fi

# Add n related variables
export N_PREFIX="$HOME/.local"

# Add Python related PATH
if [ -d "$HOME/.poetry" ]; then
  export PATH="$HOME/.poetry/bin:$PATH"
fi

# Add Go related PATH
export GOPATH="$HOME/go"

if [ -d "$GOPATH" ]; then
  export PATH="$GOPATH/bin:$PATH"
fi

if [ -d "/usr/local/go/bin" ]; then
  export PATH="/usr/local/go/bin:$PATH"
fi

# Add Rust related PATH
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Add git-toolbelt
if [ -d "$HOME/git-toolbelt" ]; then
  export PATH="$PATH:$HOME/git-toolbelt"
fi

# Add default less options
# -F to quit automatically if the file is shorter than the screen
# -X to not clear the screen after quitting
# -R to show only color escape sequences in raw form
# -M to show a more verbose prompt
export LESS="FXRM"

alias r='ranger'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -alF'
alias la='ls -A'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
