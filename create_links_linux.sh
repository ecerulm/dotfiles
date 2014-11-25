#!/bin/bash
# dotfiles in the home dir
set -e 

ls -A | grep "^\." | grep -v "^\.git$" | grep -v "^\.tmux.conf." | xargs -n1 -I'{}' ln -Tvfs ~/dotfiles/'{}' ~/'{}'

# Fish config files
mkdir -p ~/.config/fish/
ln -Tvfs ~/dotfiles/fishfunctions ~/.config/fish/functions
ln -Tvfs ~/dotfiles/config.fish ~/.config/fish/config.fish

# bin 
mkdir -p ~/bin
ls bin | xargs -n1 -I'{}' ln -Tvfs ~/dotfiles/bin/'{}' ~/bin/'{}'

#create system specific symlinks
ln -Tvfs ~/dotfiles/.gitconfig_linux .gitconfig_platform_specific
ln -Tvfs ~/dotfiles/.gitconfig_linux ~/.gitconfig_platform_specific
ln -Tvfs ~/dotfiles/.tmux.conf.linux ~/.tmux.conf.extra

# add text

mkdir -pv ~/.vim-tmp
mkdir -pv ~/.tmp
mkdir -pv ~/tmp

#Install powerline fonts
mkdir -pv ~/.fonts
cp -v ~/dotfiles/fonts/PowerlineSymbols.otf ~/.fonts
fc-cache -vf ~/.fonts/
mkdir -pv ~/.config/fontconfig/conf.d
cp -v ~/dotfiles/fonts/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/




