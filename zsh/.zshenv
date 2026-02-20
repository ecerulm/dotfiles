# This file is  source for interactive and non-interative shells
# Do not put aliases , or anything that will change the behaviour 
# tools like make will open shells to execute commands, the aliases
# here will affect those shells

# This is the place for changing @PATH, $EDITOR, $PAGER, 

# fpath is the search path for function definitions
fpath+=~/dotfiles/zsh/my-zsh-functions


export PAGER="less" # unset PAGER
export LESS="-FRX"
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_DEFAULT_COMMAND="fd ."


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.local/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/google-cloud-sdk/completion.zsh.inc"; fi

# Rust / Rustup / Cargo
[ -f "$HOME/.cargo/env" ] && . "${HOME}/.cargo/env"


# NVIM_HOME="$HOME/opt/nvim/"
# if [[ -d "$NVIM_HOME/bin" ]]; then
# 	path=("$NVIM_HOME/bin" $path)
# fi

# For things that you don't want to share between all your machines 
[ -f ~/.zshenv.thismachine ] && . ~/.zshenv.thismachine
