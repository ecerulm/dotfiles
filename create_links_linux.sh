#!/bin/bash
# dotfiles in the home dir
ls -A | grep "^\." | grep -v "^\.git$" | xargs -n1 -I'{}' ln -Tvfs ~/dotfiles/'{}' ~/'{}'

# Fish config files
mkdir -p ~/.config/fish/
ln -Tvfs ~/dotfiles/fishfunctions ~/.config/fish/functions

# bin 
mkdir -p ~/bin
ls bin | xargs -n1 -I'{}' ln -Tvfs ~/dotfiles/bin/'{}' ~/bin/'{}'

#create system specific symlinks
ln -Tvfs ~/dotfiles/.gitconfig_linux .gitconfig_platform_specific
ln -Tvfs ~/dotfiles/.gitconfig_linux ~/.gitconfig_platform_specific
