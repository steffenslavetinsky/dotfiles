#!/usr/bin/env bash
#
# Homebrew

. scripts/printutils.sh

if [[ $UNAME == "mac" ]]; then
  # Check for Homebrew
  if test ! "$(which brew)"
  then
    info "  Installing Homebrew for you."
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
  fi

  # Install homebrew packages
  brew install grc coreutils spark asdf direnv fzf ripgrep
  brew install --cask karabiner-elements
else
  info "  Skipping Homebrew install"
fi

exit 0
