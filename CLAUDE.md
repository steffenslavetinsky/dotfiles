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

### Chezmoi-managed targets (deployed to $HOME)

- `dot_zshrc.tmpl` → `~/.zshrc` — template using `{{ .chezmoi.sourceDir }}` to reference source dir
- `private_dot_ssh/config` → `~/.ssh/config`
- `private_dot_ssh/configs/encrypted_*.age` → `~/.ssh/configs/{home,server}` — age-encrypted
- `private_dot_config/nvim/init.vim` → `~/.config/nvim/init.vim`

### Non-managed files (consumed directly from source dir)

These are NOT deployed to $HOME — they stay in the repo and are referenced at runtime via `$DOTFILES_ROOT` (which resolves to `~/.local/share/chezmoi`):
- `zsh/config/*.zsh` — shell config, sourced in alphabetical order by numeric prefix
- `zsh/themes/`, `zsh/functions/` — zsh theme and autoloaded functions
- `git/aliases.zsh`, `nvim/aliases.zsh` — sourced by `30_aliases.zsh`
- `bin/os_name` — returns "mac"/"linux"/"unknown", added to PATH

These are excluded via `.chezmoiignore`.

### Install scripts (`run_once_*`)

Chezmoi runs these once (tracked by content hash). `_before_` scripts run before file deployment:
- `run_once_before_01-homebrew.sh.tmpl` — brew packages (Darwin only)
- `run_once_before_02-zsh.sh.tmpl` — zsh + zplug install
- `run_once_03-git-config.sh` through `run_once_10-macos-hammerspoon.sh.tmpl`

OS-conditional scripts use Go templates: `{{ if eq .chezmoi.os "darwin" }}`.

### Zsh config loading

`~/.zshrc` → `zsh/config/main.zsh` (in source dir), which sources all `zsh/config/*.zsh` in order:
- `10_env.zsh` — PATH and env vars
- `15_functions.zsh` — autoloaded functions from `zsh/functions/`
- `20_base.zsh` — zplug plugins, history, completions, direnv
- `30_aliases.zsh` — aliases (also sources `git/aliases.zsh` and `nvim/aliases.zsh`)
- `90_final.zsh` — asdf setup

### Encryption

SSH configs are encrypted with [age](https://age-encryption.org/). The key lives at `~/.config/chezmoi/key.txt` (not in repo). Configuration is in `.chezmoi.toml.tmpl`.

### Template data

`.automations_repo_path` — set per-machine during `chezmoi init`, used by bunch and hammerspoon scripts.
