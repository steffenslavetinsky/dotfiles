#!/usr/bin/env bash
# Claude Code status line script
# Reads JSON from stdin as documented in the statusLine spec.

input=$(cat)

cwd=$(echo "$input"  | jq -r '.workspace.current_dir')
dir=$(basename "$cwd")
branch=$(cd "$cwd" 2>/dev/null && git -c core.useBuiltinFSMonitor=false rev-parse --abbrev-ref HEAD 2>/dev/null)
model=$(echo "$input" | jq -r '.model.display_name')
mode=$(echo "$input"  | jq -r '.output_style.name // empty')
used=$(echo "$input"  | jq -r '.context_window.used_percentage // empty')

# ── ANSI color helpers (bright/bold variants for high visibility) ───────────
RESET=$'\033[0m'
BOLD=$'\033[1m'

# Directory & arrow  – bright cyan
CLR_DIR=$'\033[96m'
# Git branch         – bright yellow
CLR_BRANCH=$'\033[93m'
# Git label          – bright white
CLR_GIT=$'\033[97m'
# Model name         – bright magenta
CLR_MODEL=$'\033[95m'
# Context bar fill   – bright green
CLR_BAR_FILL=$'\033[92m'
# Context bar empty  – dark grey
CLR_BAR_EMPTY=$'\033[90m'
# Context percentage – bright green
CLR_PCT=$'\033[92m'
# Context warn       – bright red (> 80 %)
CLR_PCT_WARN=$'\033[91m'

# ── Plan-mode badge ─────────────────────────────────────────────────────────
# Bright yellow background, black text → impossible to miss
CLR_PLAN_BG=$'\033[1;30;103m'   # bold, black fg, bright-yellow bg
CLR_PLAN_RESET=$'\033[0m'

if [ "$mode" = "plan" ] || [ "$mode" = "Plan" ]; then
  mode_badge=$(printf "${CLR_PLAN_BG} PLAN ${CLR_PLAN_RESET} ")
else
  mode_badge=''
fi

# ── Context bar ─────────────────────────────────────────────────────────────
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  filled=$((pct / 5))
  empty=$((20 - filled))
  bar_fill=$(printf '%0.s█' $(seq 1 $filled) 2>/dev/null)
  bar_empty=$(printf '%0.s░' $(seq 1 $empty) 2>/dev/null)
  bar=$(printf "${CLR_BAR_FILL}%s${CLR_BAR_EMPTY}%s${RESET}" "$bar_fill" "$bar_empty")
  if [ "$pct" -ge 80 ]; then
    pct_color="$CLR_PCT_WARN"
  else
    pct_color="$CLR_PCT"
  fi
  ctx_part=$(printf ' %s[%s] %s%s%%%s' "${CLR_GIT}" "$bar" "$pct_color" "$pct" "$RESET")
else
  ctx_part=''
fi

# ── Model part ──────────────────────────────────────────────────────────────
model_part=$(printf " ${CLR_MODEL}%s${RESET}" "$model")

# ── Assemble ────────────────────────────────────────────────────────────────
arrow=$(printf "${BOLD}${CLR_DIR}➜${RESET}")
dir_part=$(printf "${CLR_DIR}%s${RESET}" "$dir")

if [ -n "$branch" ]; then
  git_part=$(printf " ${CLR_GIT}git:(${CLR_BRANCH}%s${CLR_GIT})${RESET}" "$branch")
  printf "%s%s %s%s%s%s\n" "$mode_badge" "$arrow" "$dir_part" "$git_part" "$model_part" "$ctx_part"
else
  printf "%s%s %s%s%s\n" "$mode_badge" "$arrow" "$dir_part" "$model_part" "$ctx_part"
fi
