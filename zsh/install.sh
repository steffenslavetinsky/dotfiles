#!/usr/bin/env bash

. scripts/printutils.sh

zsh --version
if [ $? -eq 0 ]; then
    echo "Zsh already installed"
else
  if [[ $UNAME == "linux" ]]; then
    info "installing zsh on linux..."
    sudo apt-get install zsh
    chsh -s "$(which zsh)"
  elif [[ $UNAME == "mac" ]]; then
    info "installing zsh on mac..."
    brew install zsh
  fi

  zplug --version
  if [ $? -eq 0 ]; then
      echo "Zplug already installed"
  else
    info "installing zplug..."
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  fi

  zsh

  info "zsh installed: $(zsh --version)"
fi


