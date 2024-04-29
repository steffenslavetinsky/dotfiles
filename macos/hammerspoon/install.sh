#!/usr/bin/env bash

brew install hammerspoon --cask

if [ -z "${AUTOMATIONS_REPO_PATH}" ]; then
    echo "ERROR: AUTOMATIONS_REPO_PATH is not set."
    exit 1
fi

defaults write org.hammerspoon.Hammerspoon MJConfigFile "$AUTOMATIONS_REPO_PATH/hammerspoon/init.lua"