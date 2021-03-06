#!/bin/bash
# dotfiles in the home dir
set -euxo pipefail
# e : fail as soon as a command fails, don't continue
# u : fail if nonexisting variable can't be expanded
# x : echo each line as it's executed
# -o pipefail: fail if a command in a pipe returns status != 0


# just link all the .xxx files in this dir to ~/.xxx
ls -A | grep "^\." | grep -v "^\.git$" | grep -v "^\.tmux.conf." | xargs -n1 -I'{}' ln -Tvfs ~/dotfiles/'{}' ~/'{}'

# Fish config files
mkdir -p ~/.config/fish/
ln -Tvfs ~/dotfiles/fishfunctions ~/.config/fish/functions
ln -Tvfs ~/dotfiles/config.fish ~/.config/fish/config.fish

# sbt
mkdir -p ~/.sbt/0.13/
ln -Tvfs ~/.sbt/0.13/plugins/ ~/dotfiles/sbt/0.13/plugins/plugins.sbt
mkdir -p ~/.sbt/1.0/
ln -Tvfs ~/.sbt/1.0/plugins/ ~/dotfiles/sbt/1.0/plugins/plugins.sbt 

# NeoVim config files
ln -Tvfs ~/dotfiles/neovim ~/.config/nvim

mkdir -p ~/.config/
ln -Tvfs ~/dotfiles/qtile ~/.config/qtile

# bin
mkdir -p ~/bin
ls bin | xargs -n1 -I'{}' ln -Tvfs ~/dotfiles/bin/'{}' ~/bin/'{}'

#create system specific symlinks
ln -Tvfs ~/dotfiles/.gitconfig_linux .gitconfig_platform_specific
ln -Tvfs ~/dotfiles/.gitconfig_linux ~/.gitconfig_platform_specific
ln -Tvfs ~/dotfiles/.tmux.conf.linux ~/.tmux.conf.extra
ln -Tvfs ~/dotfiles/.bashrc.linux ~/.bashrc.extra
ln -Tvfs ~/dotfiles/.ripgreprc ~/.ripgreprc

#emacs dirs
ln -Tvfs ~/dotfiles/emacs.d ~/.emacs.d

#dircolors
ln -Tvfs ~/dotfiles/.dircolors ~/.dircolors


# create tmp dirs
mkdir -p ~/.vim-tmp
mkdir -p ~/.tmp
mkdir -p ~/tmp

mkdir -pv ~/.vim-tmp
mkdir -pv ~/.tmp
mkdir -pv ~/tmp

#Install powerline fonts
mkdir -pv ~/.fonts
cp -v ~/dotfiles/fonts/PowerlineSymbols.otf ~/.fonts
fc-cache -vf ~/.fonts/ || true
mkdir -pv ~/.config/fontconfig/conf.d
cp -v ~/dotfiles/fonts/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# echo "creating systags"
# ctags -R -f ~/.vim/systags /usr/include /usr/local/include

echo "update the plugins"
(cd ~/dotfiles; git submodule init; git submodule update)
# echo "Generate help tags for ~/.vim/doc"
# (vim -u NONE -N "+helptags ~/.vim/doc" "+qall")
echo "Install neovim plugins with vim-plug"
# (vim -u ~/.vim/vundle.vim -N +PluginInstall +PluginClean +qall)
(nvim -N +PlugInstall +PlugClean +qall)
(nvim -N +UpdateRemotePlugins +qall)
# echo "compile vimproc"
# (cd ~/.vim/bundle/vimproc.vim && make)
# echo "compile YouCompleteMe"
# (cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer) # python is implied
