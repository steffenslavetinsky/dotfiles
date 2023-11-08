#!/usr/bin/env bash
# setting defaults for macos
# see https://macos-defaults.com for a list of defaults

set -x

# Dock
defaults write com.apple.dock "static-only" -bool "true"

# Finder
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

# MenuBar
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "false"