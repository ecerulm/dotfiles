[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
export EDITOR=vim
export SHELL=/home/ecerulm/local/bin/zsh
alias tmux='LD_LIBRARY_PATH=/home/ecerulm/local/lib tmux' 

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
