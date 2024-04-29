#!/usr/bin/env bash

set -e

cd ${0%/*}/.. || exit 1    # Run from this directory

export PATH="$PATH:$(pwd)/bin"

. scripts/printutils.sh

export UNAME="$(os_name)"

# if not on macos exclude macos install scripts
find_install_scripts="find . -type f -not -path \"./scripts/*\""
if [[ $UNAME != "mac" ]]; then
    find_install_scripts+=" -not -path \"./macos/*\""
fi
find_install_scripts+=" -name 'install.sh'"


for file in $( eval "$find_install_scripts" ); do
    info "Installing $file"
    bash "$file" -H || fail "Error installing $file"
done