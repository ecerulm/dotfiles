fpath+=~/dotfiles/zsh/my-zsh-functions

export PAGER="less" # unset PAGER

export LESS="-FRX"
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_DEFAULT_COMMAND="fd ."

[ -f ~/.zshenv.thismachine ] && . ~/.zshenv.thismachine

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ecerulm/.local/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ecerulm/.local/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ecerulm/.local/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ecerulm/.local/google-cloud-sdk/completion.zsh.inc'; fi
