#!/usr/bin/env zsh
#
# bootstrap installs and links thinks.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

set -e
set -x

echo ''

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

link_file() {
	local src=$1 dst=$2

    local overwrite= backup= skip=
    local action=

    if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]
    then

      if [ "$overwrite_all" = "false" ] && [ "$backup_all" = "false" ] && [ "$skip_all" = "false" ]
      then

        local currentSrc="$(readlink $dst)"

        if [ "$currentSrc" = "$src" ]
        then

          skip=true;

        else

          user "File already exists: $(basename "$src"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
          read action
          echo ''

          case "$action" in
            o)
              overwrite=true;;
            O)
              overwrite_all=true;;
            b)
              backup=true;;
            B)
              backup_all=true;;
            s)
              skip=true;;
            S)
              skip_all=true;;
            *)
              echo "nothing matched"
              ;;
          esac

        fi

      fi

      overwrite=${overwrite:-$overwrite_all}
      backup=${backup:-$backup_all}
      skip=${skip:-$skip_all}

      if [ "$overwrite" = "true" ]
      then
        rm -rf "$dst"
        success "removed $dst"
      fi

      if [ "$backup" = "true" ]
      then
        mv "$dst" "${dst}.backup"
        success "moved $dst to ${dst}.backup"
      fi

      if [ "$skip" = "true" ]
      then
        success "skipped $src"
      fi
    fi

    if [ "$skip" != "true" ]  # "false" or empty
    then
      ln -s "$1" "$2"
      success "linked $1 to $2"
    fi
}

install_dotfiles() {
	echo 'installing dotfiles'

	local overwrite_all=false backup_all=false skip_all=false

	# find all files in dotfiles that should be symlinked in directory
	# shellcheck disable=SC2044
	for file in $(find "$DOTFILES_ROOT" -maxdepth 3 -name '*.symlink'); do

    dst="$HOME/.$(basename "${file%.*}")"

	  # check if there is another location specified for the symlink
	  # this is done by setting location: ... in the first line
	  matching_line=$(sed -n '1s/[#"] location: \(.*\)/\1/p' "$file")
	  if [ -n "$matching_line" ]; then
	    info "found location: $matching_line for $file"
      dst="$matching_line"
    fi

    link_file "$file" "$( eval echo "$dst" )"
  done
}

install_dotfiles

echo ''
echo '  All installed!'
