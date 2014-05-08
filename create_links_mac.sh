#!/bin/bash
ls -A | grep "^\." | grep -v "^\.git$" | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/'{}' ~/'{}'
mkdir -p ~/bin
ls bin | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/bin/'{}' ~/bin/'{}'
#create system specific symlinks
ln -Fvhfs ~/dotfiles/.gitconfig_osx .gitconfig_platform_specific
ln -Fvhfs ~/dotfiles/.gitconfig_osx ~/.gitconfig_platform_specific
