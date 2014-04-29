#!/bin/bash
ls -A | grep "^\." | grep -v "^\.git$" | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/'{}' ~/'{}'
mkdir -p ~/bin
ls bin | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/bin/'{}' ~/bin/'{}'
