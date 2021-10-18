# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.rvm/bin" ]; then
    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi

# test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
# test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

if [ $(type -P "brew") ]; then # or $(type -P "brew")
    export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi



PYENV_ROOT="$HOME/.pyenv"

if [ -d $PYENV_ROOT ]; then
  export PYENV_ROOT
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1


  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi


# if running bash, you want this at the end so that pyenv path is before brew path, 
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# added by Snowflake SnowSQL installer v1.0
[ -d "/Applications/SnowSQL.app/Contents/MacOS" ] && export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

