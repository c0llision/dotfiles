#!/bin/bash
mkdir ~/.dotfiles.old
mkdir ~/.ssh

mv ~/.aliases ~/.dotfiles.old/
cp aliases ~/.aliases

mv ~/.curlrc ~/.dotfiles.old/
cp curlrc ~/.curlrc

mv ~/.gdbinit ~/.dotfiles.old/
cp gdbinit ~/.gdbinit

mv ~/.gitconfig ~/.dotfiles.old/
cp gitconfig ~/.gitconfig

mv ~/.inputrc ~/.dotfiles.old/
cp inputrc ~/.inputrc

mv ~/.profile ~/.dotfiles.old/
cp profile ~/.profile

mv ~/.vimrc ~/.dotfiles.old/
cp vimrc ~/.vimrc

mv ~/.ssh/config ~/.dotfiles.old/.ssh_config
cp ssh_config ~/.ssh/config

mv ~/.ssh/config_tor ~/.dotfiles.old/.ssh_config_tor
cp ssh_config_tor ~/.ssh/config_tor

mv ~/.tmux.conf ~/.dotfiles.old/.tmux.conf
cp tmux.conf ~/.tmux.conf
