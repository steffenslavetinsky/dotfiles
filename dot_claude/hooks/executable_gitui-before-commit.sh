#!/bin/bash
# Intercepts git commit to always prompt for user approval (review with gitui first).
# Per-session escape hatch: the sentinel file is keyed by session id, so switching the
# gate off in one Claude session leaves every other session gated.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
SENTINEL="/tmp/claude/commit-gate-off-$SESSION_ID"

mkdir -p /tmp/claude 2>/dev/null || true

if [[ "$COMMAND" =~ git[[:space:]]+commit ]] && [[ ! -f "$SENTINEL" ]]; then
    P='\033[38;2;250;179;135m'  # Cappuccino Peach
    R='\033[0m'
    printf >&2 "\n${P} 🔍 Review before commit!${R}\n"
    printf >&2 "${P}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}\n"
    printf >&2 "${P} Open another terminal and${R}\n"
    printf >&2 "${P} run ${R}gitui${P} to inspect${R}\n"
    printf >&2 "${P} the staged changes.${R}\n\n"
    printf >&2 "${P} Skip this gate for the rest${R}\n"
    printf >&2 "${P} of the session:${R}\n"
    printf >&2 " touch $SENTINEL\n\n"
    jq -n '{
        hookSpecificOutput: {
            hookEventName: "PreToolUse",
            permissionDecision: "ask"
        }
    }'
    exit 0
fi

exit 0
