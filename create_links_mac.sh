#!/bin/bash


# ln -Fvhfs
# -s : Create symbolic link
# -F : If the target file already exists and is a directory, the remove it so that the link may occur. This option need to be use together with -f or -i
# -f : force (opposed to -i which means interactive, as in present a prompt to the user)
# -v : verbose
# -h : If the target_file or target_dir is a symbolic link, do not follow it. This is useful together with -f to replace a symlink which may point to a directory

# dotfiles in the home dir
ls -A | grep "^\." | grep -v "^\.git$" | grep -v "^\.tmux.conf." | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/'{}' ~/'{}'

# Fish config files
mkdir -p ~/.config/fish/
ln -Fvhfs ~/dotfiles/fishfunctions ~/.config/fish/functions
ln -Fvhfs ~/dotfiles/config.fish ~/.config/fish/config.fish

# pet config files
mkdir -p ~/.config/pet
ln -Fvhfs ~/dotfiles/pet/config.toml ~/.config/pet/config.toml
ln -Fvhfs ~/dotfiles/pet/snippet.toml ~/.config/pet/snippet.toml

# SBT
mkdir -p ~/.sbt/0.13/plugins
ln -Fvhfs ~/dotfiles/sbt/0.13/plugins/plugins.sbt ~/.sbt/0.13/plugins/
mkdir -p ~/.sbt/1.0/plugins
ln -Fvhfs ~/dotfiles/sbt/1.0/plugins/plugins.sbt ~/.sbt/1.0/plugins/

# NeoVim config files
ln -Fvhfs ~/dotfiles/neovim ~/.config/nvim


# KiTTY config
mkdir -p ~/.config/kitty
ln -Fvhfs ~/dotfiles/kitty ~/.config/kitty

# don't copy qtile config in mac it doesn't make sense in macosx
#mkdir -p ~/.config/
#ln -Fvhfs ~/dotfiles/qtile ~/.config/qtile

#bin
mkdir -p ~/bin
ls bin | xargs -n1 -I'{}' ln -Fvhfs ~/dotfiles/bin/'{}' ~/bin/'{}'

#create system specific symlinks
ln -Fvhfs ~/dotfiles/.gitconfig_osx ~/.gitconfig_platform_specific
ln -Fvhfs ~/dotfiles/.tmux.conf.macosx ~/.tmux.conf.extra
ln -Fvhfs ~/dotfiles/.bashrc.macosx ~/.bashrc.extra
mkdir -p ~/.config/
# ln -Fvhfs ~/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json
ln -Fvhfs ~/dotfiles/karabiner ~/.config/karabiner
# Unfortunately karabiner will remove the symbolic links 

ln -Fvhfs ~/dotfiles/.ripgreprc ~/.ripgreprc


# emacs dirs
ln -Fvhfs ~/dotfiles/emacs.d ~/.emacs.d

# dircolors
ln -Fvhfs ~/dotfiles/.dircolors ~/.dircolors

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
echo "submodule update"
(cd ~/dotfiles; git submodule init; git submodule update)
# echo "Generate help tags for ~/.vim/doc"
# (vim -u NONE -N "+helptags ~/.vim/doc" "+qall")
echo "Install vim plugins with vim-plug"
# (vim -u ~/.vim/vundle.vim -N +PluginInstall +PluginClean +qall)
#neovim
(nvim -N +PlugInstall +PlugClean +qall)
(nvim +UpdateRemotePlugins +qall)
# echo "install vimproc"
# (cd ~/.vim/bundle/vimproc.vim && make)
# echo "install YouCompleteMe"
# (cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer) # python is implied
