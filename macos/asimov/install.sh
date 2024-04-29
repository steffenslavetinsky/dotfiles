#!/usr/bin/env bash

brew install hammerspoon --cask

defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/Code/Steffen/automations/hammerspoon/init.lua"