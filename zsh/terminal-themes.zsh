# Terminal theme definitions for Ghostty
# Each theme is "background foreground"
# Base themes are defined here; project themes are appended by terminal_theme_init
typeset -gA TERMINAL_THEMES
TERMINAL_THEMES=(
  default "#f5f5f0 #2e3440"
)

# Load project themes from file (one per line: name background foreground)
if [[ -f "$DOTFILES_ROOT/zsh/terminal-themes.conf" ]]; then
  while IFS=' ' read -r _tname _tbg _tfg; do
    [[ -z "$_tname" || "$_tname" == \#* ]] && continue
    TERMINAL_THEMES[$_tname]="$_tbg $_tfg"
  done < "$DOTFILES_ROOT/zsh/terminal-themes.conf"
  unset _tname _tbg _tfg
fi
