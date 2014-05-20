#!/bin/bash

# dotfiles in the home dir
ls -A | grep "^\." | grep -v "^\.git$" | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/'{}' ~/'{}'

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
