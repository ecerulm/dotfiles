# .bash_profile is executed only for login shell (ssh or terminal emulator) 
# and it's executed first, from this one we source .bashrc
# So only put in this file things that should ONLY RUN if the shell is interactive
# for things that should be run for both interactive and non-interactive (most stuff) then put it in ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

. ~/.bashrc

if brew --prefix asdf >/dev/null 2>&1; then
  ASDFSX=$(brew --prefix asdf)/libexec/asdf.sh
  if [ -x  "$ASDFSH" ]; then
    . "$ASDFSH"
  fi
fi

. "$HOME/.cargo/env"

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
