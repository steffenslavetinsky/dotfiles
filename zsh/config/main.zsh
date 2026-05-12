ZSH_CONFIG_ROOT="$(dirname "$0")"
export DOTFILES_ROOT="${ZSH_CONFIG_ROOT:A:h:h}"

for file in "$ZSH_CONFIG_ROOT"/*.zsh; do
    if [[ "$file" != "$ZSH_CONFIG_ROOT/main.zsh" ]]; then
        source "$file"
    fi
done

# Machine-specific overrides (not tracked by chezmoi)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
