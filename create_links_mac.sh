#!/bin/bash

# dotfiles in the home dir
ls -A | grep "^\." | grep -v "^\.git$" | grep -v "^\.tmux.conf." | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/'{}' ~/'{}'

# Fish config files
mkdir -p ~/.config/fish/
ln -Fvhfs ~/dotfiles/fishfunctions ~/.config/fish/functions
ln -Fvhfs ~/dotfiles/config.fish ~/.config/fish/config.fish

#bin 
mkdir -p ~/bin
ls bin | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/bin/'{}' ~/bin/'{}'

#create system specific symlinks
ln -Fvhfs ~/dotfiles/.gitconfig_osx .gitconfig_platform_specific
ln -Fvhfs ~/dotfiles/.gitconfig_osx ~/.gitconfig_platform_specific
ln -Fvhfs ~/dotfiles/.tmux.conf.macosx ~/.tmux.conf.extra

# emacs dirs
ln -Fvhfs ~/dotfiles/emacs.d ~/.emacs.d

# create tmp dirs
mkdir -p ~/.vim-tmp
mkdir -p ~/.tmp
mkdir -p ~/tmp

mkdir -pv ~/.vim-tmp
mkdir -pv ~/.tmp
mkdir -pv ~/tmp
# create tmp dirs
mkdir -p ~/.vim-tmp
mkdir -p ~/.tmp
mkdir -p ~/tmp

# echo "creating systags"
# ctags -R -f ~/.vim/systags /usr/include /usr/local/include

echo "update the plugins"
(cd ~/dotfiles; git submodule init; git submodule update)
(vim -u ~/.vim/vundle.vim -N +PluginInstall +PluginClean +qall)

