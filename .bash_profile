# .bash_profile is executed only for login shell (ssh or terminal emulator) 
# and it's executed first, from this one we source .bashrc
# So only put in this file things that should ONLY RUN if the shell is interactive
# for things that should be run for both interactive and non-interactive (most stuff) then put it in ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

. ~/.bashrc

if brew --prefix asdf >/dev/null 2>&1; then
. $(brew --prefix asdf)/libexec/asdf.sh
fi
. "$HOME/.cargo/env"
