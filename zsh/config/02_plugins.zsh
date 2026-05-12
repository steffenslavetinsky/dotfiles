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

# asdf
if [[ $UNAME == "mac" && -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [[ -f "$HOME/.asdf/asdf.sh" ]]; then
  source "$HOME/.asdf/asdf.sh"
fi
