fpath+=~/dotfiles/zsh/my-zsh-functions

export PAGER="less" # unset PAGER

export LESS="-FRX"
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_DEFAULT_COMMAND="fd ."

[ -f ~/.zshenv.thismachine ] && . ~/.zshenv.thismachine
