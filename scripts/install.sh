#!/usr/bin/env bash

set -e

cd ${0%/*}/.. || exit 1    # Run from this directory

export PATH="$PATH:$(pwd)/bin"

. scripts/printutils.sh

export UNAME="$(os_name)"

for file in $(find . -type f -not -path "./scripts/*" -name 'install.sh'); do
    info "Installing $file"
    bash "$file" -H || fail "Error installing $file"
done