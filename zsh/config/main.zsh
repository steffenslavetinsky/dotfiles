ZSH_CONFIG_ROOT="$(dirname "$0")"
export DOTFILES_ROOT="$ZSH_CONFIG_ROOT/../.."

for file in "$ZSH_CONFIG_ROOT"/*.zsh; do
    if [[ "$file" != "$ZSH_CONFIG_ROOT/main.zsh" ]]; then
        source "$file"
    fi
done
