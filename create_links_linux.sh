#!/bin/bash
ls -A | grep "^\." | xargs -n1 -I'{}' ln -Tvfs ~/dotfiles/'{}' ~/'{}' 
