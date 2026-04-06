# Steffen's .dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Setup on a new machine

```bash
brew install chezmoi age
chezmoi init --apply https://github.com/steffenslavetinsky/dotfiles.git
```

You'll need to place your age decryption key at `~/.config/chezmoi/key.txt` before applying (for encrypted SSH configs).

## Day-to-day usage

```bash
chezmoi apply          # apply changes from source to home
chezmoi diff           # preview what would change
chezmoi edit ~/.zshrc  # edit a managed file
chezmoi add <file>     # start managing a new file
chezmoi cd             # cd into the source directory
```
