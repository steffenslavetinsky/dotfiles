#!/usr/bin/env bash
# Shared GitUI review gate for agent harnesses.
# Usage: gitui-review-gate.sh commit|push <session-id>
# Exit 2 means the harness must ask the user before it continues.

set -euo pipefail

ACTION="${1:-}"
SESSION_ID="${2:-unknown}"
SENTINEL="/tmp/claude/commit-gate-off-$SESSION_ID"

P='\033[38;2;250;179;135m'  # Cappuccino Peach
R='\033[0m'

mkdir -p /tmp/claude 2>/dev/null || true

case "$ACTION" in
  commit)
    [[ -f "$SENTINEL" ]] && exit 0
    printf >&2 "\n${P} 🔍 Review before commit!${R}\n"
    printf >&2 "${P}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}\n"
    printf >&2 "${P} Open another terminal and${R}\n"
    printf >&2 "${P} run ${R}gitui${P} to inspect${R}\n"
    printf >&2 "${P} the staged changes.${R}\n\n"
    printf >&2 "${P} Skip this gate for the rest${R}\n"
    printf >&2 "${P} of the session:${R}\n"
    printf >&2 " touch $SENTINEL\n\n"
    exit 2
    ;;
  push)
    printf >&2 "\n${P} 🔍 Review before push!${R}\n"
    printf >&2 "${P}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}\n"
    printf >&2 "${P} Open another terminal and${R}\n"
    printf >&2 "${P} run ${R}gitui${P} to inspect${R}\n"
    printf >&2 "${P} the commits about to ship.${R}\n\n"
    exit 2
    ;;
  *)
    printf >&2 'usage: %s commit|push <session-id>\n' "$0"
    exit 64
    ;;
esac
