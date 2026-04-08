# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for macOS/Linux, managed with [chezmoi](https://www.chezmoi.io/). The chezmoi source directory (`~/.local/share/chezmoi`) is this repo.

## Key Commands

- `chezmoi apply` — deploy all managed files and run install scripts
- `chezmoi diff` — preview pending changes
- `chezmoi verify` — check target state matches source
- `chezmoi add [--encrypt] <file>` — start managing a new file
- `chezmoi edit <file>` — edit a managed file's source

No tests, linters, or build steps.

## Architecture

### Two categories of files

**Chezmoi-managed targets** (deployed to `$HOME`):
- `dot_zshrc.tmpl` → `~/.zshrc` — template using `{{ .chezmoi.sourceDir }}` to point into source dir
- `dot_p10k.zsh` → `~/.p10k.zsh` — Powerlevel10k prompt config
- `private_dot_ssh/` → `~/.ssh/` — includes age-encrypted configs
- `private_dot_config/nvim/init.vim` → `~/.config/nvim/init.vim`

**Non-managed files** (stay in repo, consumed at runtime via `$DOTFILES_ROOT`):
- `zsh/` — shell config, functions, plugins
- `git/aliases.zsh`, `nvim/aliases.zsh` — sourced by `03_aliases.zsh`
- `bin/os_name` — added to PATH
- `macos/` — macOS-specific data (e.g. Time Machine exclusions)

These are excluded from deployment via `.chezmoiignore`.

### Install scripts (`run_once_*`)

Chezmoi runs these once (tracked by content hash). `_before_` scripts run before file deployment:
- `run_once_before_01-homebrew.sh.tmpl` — brew packages (Darwin only)
- `run_once_before_02-zsh.sh.tmpl` — zsh install and login shell setup
- `run_once_03-git-config.sh` through `run_once_10-macos-hammerspoon.sh.tmpl`

OS-conditional scripts use Go templates: `{{ if eq .chezmoi.os "darwin" }}`.

### Zsh config loading

`~/.zshrc` → `zsh/config/main.zsh` (in source dir), which sources all `zsh/config/*.zsh` in alphabetical order:
- `01_env.zsh` — PATH, env vars, `$DOTFILES_ROOT`, autoloaded functions from `zsh/functions/`
- `02_plugins.zsh` — antidote plugin manager (self-installing), p10k, keybindings, direnv, history, fzf, asdf
- `03_aliases.zsh` — aliases (also sources `git/aliases.zsh` and `nvim/aliases.zsh`)

Plugin list is declared in `zsh/config/plugins.txt`. The generated `plugins.zsh` is gitignored.

### Encryption

SSH configs are encrypted with [age](https://age-encryption.org/). The key lives at `~/.config/chezmoi/key.txt` (not in repo). Configuration is in `.chezmoi.toml.tmpl`.

### Template data

`.automations_repo_path` — set per-machine during `chezmoi init`, used by bunch and hammerspoon scripts.
