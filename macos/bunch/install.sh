#!/usr/bin/env bash

. scripts/printutils.sh

set -e

EXIT_CODE=0
bunch --version || EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo "BunchCLI already installed"
else
  info "installing BunchCLI..."
  gem install bunchcli
fi

defaults write com.brettterpstra.Bunch NSNavLastRootDirectory "$AUTOMATIONS_REPO_PATH/bunch/bunches"
defaults write com.brettterpstra.Bunch configDir "$AUTOMATIONS_REPO_PATH/bunch/bunches"
