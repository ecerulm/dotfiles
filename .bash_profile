# .bash_profile is executed only for login shell (ssh or terminal emulator) 

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# added by Anaconda2 4.2.0 installer
#export PATH="/Users/rubenlaguna/anaconda/bin:$PATH"
if [ $(type -P "rbenv") ]; then # or $(type -P "rbenv")
  eval "$(rbenv init -)"
fi
