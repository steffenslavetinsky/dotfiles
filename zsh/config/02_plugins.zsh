ZSH_CONFIG_ROOT="$(dirname "$0")"

# Antidote plugin manager (self-installing)
ANTIDOTE_HOME="${ZDOTDIR:-$HOME}/.antidote"
[[ -d $ANTIDOTE_HOME ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
source "$ANTIDOTE_HOME/antidote.zsh"
antidote load "$ZSH_CONFIG_ROOT/plugins.txt"

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# History substring search bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=isearch
export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS='+m -x --preview-window=hidden'

# direnv
eval "$(direnv hook zsh)"

# Apply terminal theme when TERMINAL_THEME changes (via direnv)
_TERMINAL_THEME_CURRENT=""
_terminal_theme_precmd() {
  local target="${TERMINAL_THEME:-default}"
  if [[ "$target" != "$_TERMINAL_THEME_CURRENT" ]]; then
    terminal_theme "$target"
    _TERMINAL_THEME_CURRENT="$target"
  fi
}
autoload -U add-zsh-hook
add-zsh-hook precmd _terminal_theme_precmd

# History
export HISTFILE=~/.zsh_history
export SAVEHIST=1000000
export HISTSIZE=100000
setopt inc_append_history
setopt HIST_IGNORE_ALL_DUPS
setopt share_history

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

export GPG_TTY=$(tty)

# asdf: shims first, so Homebrew binaries do not shadow .tool-versions
if (( $+commands[asdf] )); then
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  path=("$ASDF_DATA_DIR/shims" $path)
fi
