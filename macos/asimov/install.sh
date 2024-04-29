#!/usr/bin/env bash

if [ ! -d ./repos/asimov ]; then
  echo "Cloning asimov."
  git clone https://github.com/steffenslavetinsky/asimov.git --depth 1 ./repos/asimov
fi


# install asimov from install directory and restore the current directory
cd ./repos/asimov || exit 1
git pull
sudo ./install.sh
cd - || exit 1

