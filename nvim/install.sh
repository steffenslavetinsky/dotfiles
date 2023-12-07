#!/usr/bin/env bash

. scripts/printutils.sh

nvim --version
if [ $? -eq 0 ]; then
    echo "nvim already installed"
else
  if [[ $UNAME == "linux" ]]; then
    info "installing nvim on linux..."
    sudo apt install nvim
  elif [[ $UNAME == "mac" ]]; then
    info "installing nvim on mac..."
    brew install nvim
  fi

  info "nvim installed: $(nvim --version)"
fi

mkdir -p ~/.config/nvim