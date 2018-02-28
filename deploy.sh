#!/bin/bash
mkdir ~/.dotfiles.old

mv ~/.aliases ~/.dotfiles.old/
cp .aliases ~/

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

mv ~/.curlrc ~/.dotfiles.old/
cp .curlrc ~/

mv ~/.ssh/config ~/.dotfiles.old/.ssh-config
cp .ssh/config ~/.ssh/config
