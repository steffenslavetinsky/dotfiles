alias reload='. ~/.zshrc'
alias zshconfig="vim ~/.zshrc"

alias ll='ls -lh'
alias l='ls -a'

alias dotfiles="cd \$DOTFILES_ROOT"

. "$DOTFILES_ROOT/git/aliases.zsh"
. "$DOTFILES_ROOT/nvim/aliases.zsh"

# Claude Code wrapper: switch to project-claude theme while running
claude() {
  if [[ -n "$TERMINAL_THEME" && -n "${TERMINAL_THEMES[${TERMINAL_THEME}-claude]}" ]]; then
    terminal_theme "${TERMINAL_THEME}-claude"
    command claude "$@"
    local ret=$?
    terminal_theme "$TERMINAL_THEME"
    return $ret
  else
    command claude "$@"
  fi
}
