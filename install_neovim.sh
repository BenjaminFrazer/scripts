#!/usr/bin/env bash

set -e # exit on errors

rm -rf $HOME/local/neovim/
git clone -b v0.11.2 https://github.com/neovim/neovim.git $HOME/local/neovim 
sudo apt install cmake gettext lua5.1 liblua5.1-0-dev
cd $HOME/local/neovim
make CMAKE_BUILD_TYPE=Release
make CMAKE_INSTALL_PREFIX=$HOME/local install
