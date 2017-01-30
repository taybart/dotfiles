#!/bin/bash
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
ln -s $HOME/.dotfiles/vim $HOME/.vim
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc
ln -s $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf
mkdir -p $HOME/.config
ln -s $HOME/.dotfiles/vim $HOME/.config/nvim
