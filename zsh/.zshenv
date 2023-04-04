path+=~/.local/bin
export PATH

fpath+=~/dotfiles/zsh/my-zsh-functions

export PAGER=""

export LESS="-FRX"
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_DEFAULT_COMMAND="fd ."
[ -f ~/.zshenv.thismachine ] && . ~/.zshenv.thismachine

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(#i)(ls*|pwd*|*password*)"
zshaddhistory() {
  emulate -L zsh
  ## uncomment if HISTORY_IGNORE
  ## should use EXTENDED_GLOB syntax
  setopt extendedglob
  [[ $1 != ${~HISTORY_IGNORE} ]]
}
