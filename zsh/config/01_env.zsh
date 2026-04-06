case "$(uname)" in
  Darwin) export UNAME="mac" ;;
  Linux)  export UNAME="linux" ;;
  *)      export UNAME="unknown" ;;
esac

export GOPATH="$HOME/go"
export SSH_CONFIG="$DOTFILES_ROOT/ssh/configs/home"

typeset -U path
path=($DOTFILES_ROOT/bin /usr/local/go/bin $GOPATH/bin $path)

fpath=($DOTFILES_ROOT/zsh/functions ~/.zsh_completions $fpath)
autoload -Uz spectrum_ls
