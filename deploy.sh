#!/bin/bash
mkdir ~/.dotfiles.old

mv ~/.aliases ~/.dotfiles.old/
cp .aliases ~/

mv ~/.curlrc ~/.dotfiles.old/
cp .curlrc ~/

mv ~/.gdbinit ~/.dotfiles.old/
cp .gdbinit ~/

mv ~/.gitconfig ~/.dotfiles.old/
cp .gitconfig ~/

mv ~/.inputrc ~/.dotfiles.old/
cp .inputrc ~/

mv ~/.profile ~/.dotfiles.old/
cp .profile ~/

mv ~/.vimrc ~/.dotfiles.old/
cp .vimrc ~/

mv ~/.ssh/config ~/.dotfiles.old/.ssh-config
cp .ssh/config ~/.ssh/config

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
