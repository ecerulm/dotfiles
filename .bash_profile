# .bash_profile is executed only for login shell (ssh or terminal emulator) 



test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# added by Anaconda2 4.2.0 installer
#export PATH="/Users/rubenlaguna/anaconda/bin:$PATH"
if [ $(type -P "rbenv") ]; then # or $(type -P "rbenv")
  eval "$(rbenv init -)"
fi

if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  export MANPATH="$(brew --prefix)/share/man:$MANPATH"
  export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"
  export XDG_DATA_DIRS="$(brew --prefix)/share:$XDG_DATA_DIRS"
fi

if [ $(type -P "brew") ]; then # or $(type -P "brew")
  export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi

export LC_ALL="en_US.UTF-8"

# we do this at the end so that pyenv path is before brew path
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

##THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="/Users/rublag/.sdkman"
#[[ -s "/Users/rublag/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/rublag/.sdkman/bin/sdkman-init.sh"
