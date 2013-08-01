#!/bin/bash
#Directories
echo "Creating directory symlinks"
ln -vFfsh ~/dotfiles/zsh ~/.zsh
ln -vFfsh ~/dotfiles/.git_template ~/.git_template
ln -vFfsh ~/dotfiles/.vim ~/.vim
mkdir -pv ~/.config/fish
ln -vFfsh ~/dotfiles/fishfunctions ~/.config/fish/functions
#Files
echo "Creating individual configuration files symlinks"
ln -vfs ~/dotfiles/gitconfig ~/.gitconfig
ln -vfs ~/dotfiles/tmux.conf ~/.tmux.conf
ln -vfs ~/dotfiles/zshrc ~/.zshrc
ln -vfs ~/dotfiles/zshenv ~/.zshenv
ln -vfs ~/dotfiles/.vimrc ~/.vimrc
ln -vfs ~/dotfiles/config.fish ~/.config/fish/config.fish




#config.fish       
#githelpers@       
#tmux.conf.linux@  
#cshrc.user@       
#inputrc@          
#tmux.conf.macosx@ 
#ctags@            
#modules           
#fishfunctions/    
#sublimetext2/     
