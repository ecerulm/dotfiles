# this is always sourced
# .zprofiles runs for login shells before this file
# .zlogin runs for login shell after this file
#
eval "$(/opt/homebrew/bin/brew shellenv)"

[ -s "/opt/homebrew/opt/asdf/libexec/asdf.sh" ] && \. /opt/homebrew/opt/asdf/libexec/asdf.sh # This loads asdf

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

if [ -d "$HOME/.pyenv" ]; then
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
fi

alias vim=nvim
alias s="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gc="git commit"
