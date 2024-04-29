#!/usr/bin/env bash

. scripts/printutils.sh

asdf --version
if [ $? -eq 0 ]; then
    echo "asdf already installed"
else
  if [[ $UNAME == "linux" ]]; then
    info "installing asdf on linux..."
    latest="$(git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' https://github.com/asdf-vm/asdf.git "v*.*.*" | tail --lines=1 | awk -F'/' '{print $NF}')"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "$latest"
  elif [[ $UNAME == "mac" ]]; then
    info "on mac asdf should be installed in the homebrew install script..."
  fi

  info "asdf installed: $(asdf --version)"
fi

asdf direnv setup --shell bash --version system

asdf plugin-add python || true
asdf plugin-add direnv || true



