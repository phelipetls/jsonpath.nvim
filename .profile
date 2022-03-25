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
  export PATH="$PATH:$HOME/bin"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$PATH:$HOME/.local/bin"
fi

# Add local scripts folder into PATH
if [ -d "$HOME/scripts" ]; then
  export PATH="$PATH:$HOME/scripts/"
fi

# Add Ubuntu snap related PATH
if [ -d "/snap/bin" ]; then
  export PATH="$PATH:/snap/bin"
fi

# Add LaTeX related PATH
if [ -d "/usr/local/texlive" ]; then
  export PATH="/usr/local/texlive/2019/bin/x86_64-linux/:$PATH"
  export MANPATH="/usr/local/texlive/2019/texmf-dist/doc/man/:$MANPATH"
  export INFOPATH="/usr/local/texlive/2019/texmf-dist/doc/info/:$INFOPATH"
fi

# Add Android SDK related PATH
if [ -d "$HOME/Android/Sdk" ]; then
  export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
elif [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_SDK_ROOT="$HOME/Library/Android/Sdk"
fi

if [ -d "$ANDROID_SDK_ROOT" ]; then
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
  export PATH="$ANDROID_SDK_ROOT/emulator:$PATH"
  export PATH="$ANDROID_SDK_ROOT/tools:$PATH"
  export PATH="$ANDROID_SDK_ROOT/tools/bin:$PATH"
  export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"
fi

# Add Android SDK related PATH
if [ -d "$HOME/android-studio/bin" ]; then
  export PATH="$PATH:$HOME/android-studio/bin"
fi

if [ -x "/usr/lib/jvm/java-11-openjdk-amd64" ]; then
  export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
fi

# Add npm related PATH
NPM_PACKAGES="$HOME/.npm-packages"

if [ -d "$NPM_PACKAGES" ]; then
  export PATH="$PATH:$NPM_PACKAGES/bin"
  export MANPATH="$MANPATH:$NPM_PACKAGES/share/man"
fi

# Add n related variables
export N_PREFIX="$HOME/.n"

if [ -d "$N_PREFIX" ]; then
  export PATH="$PATH:$N_PREFIX/bin"
fi

# Add Python related PATH
if [ -d "$HOME/.poetry" ]; then
  export PATH="$PATH:$HOME/.poetry/bin"
fi

# Add Go related PATH
export GOPATH="$HOME/go"

if [ -d "$GOPATH" ]; then
  export PATH="$PATH:$GOPATH/bin"
fi

if [ -d "/usr/local/go/bin" ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi

# Add Rust related PATH
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

# Add git-toolbelt
if [ -d "$HOME/git-toolbelt" ]; then
  export PATH="$PATH:$HOME/git-toolbelt"
fi

# Add Homebrew
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="$PATH:/opt/homebrew/bin"
fi

# Add default less options
# -F to quit automatically if the file is shorter than the screen
# -X to not clear the screen after quitting
# -R to show only color escape sequences in raw form
# -M to show a more verbose prompt
export LESS="FXRM"

alias r='ranger'
if [[ $OSTYPE != 'darwin'* ]]; then
  alias ls='ls --color=auto --group-directories-first'
fi
alias ll='ls -alF'
alias la='ls -A'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
