#!/usr/bin/env bash

set -x

. scripts/printutils.sh

direnv --version
if [ $? -eq 0 ]; then
    echo "direnv already installed"
else
  if [[ $UNAME == "linux" ]]; then
    info "installing direnv on linux..."
    curl -sfL https://direnv.net/install.sh | bash
  elif [[ $UNAME == "mac" ]]; then
    info "on mac this should be installed in the homebrew install script..."
  fi

  info "direnv installed: $(direnv --version)"
fi


