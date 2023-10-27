#!/usr/bin/env bash

set -e

cd ${0%/*}/.. || exit 1    # Run from this directory

find . -type f -name 'install.sh' | while read script; do sh -c "$script"; done