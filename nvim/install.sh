#!/usr/bin/env bash

. scripts/printutils.sh

mkdir -p ~/.config/nvim

EXIT_CODE=0
nvim --version || EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
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