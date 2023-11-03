#!/usr/bin/env bash

info() {
	printf "  [ \033[00;34m..\033[0m ] $1"
}

user() {
	printf "  [ \033[0;33m?\033[0m ] $1\n"
}

success() {
	printf "\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
	printf "\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
	echo ''
	exit
}