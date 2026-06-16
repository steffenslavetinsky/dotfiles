#!/bin/bash
# Intercepts git push to always prompt for user approval (review with gitui first)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if [[ "$COMMAND" =~ git[[:space:]]+push ]]; then
    P='\033[38;2;250;179;135m'  # Cappuccino Peach
    R='\033[0m'
    printf >&2 "\n${P} 🔍 Review before push!${R}\n"
    printf >&2 "${P}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}\n"
    printf >&2 "${P} Open another terminal and${R}\n"
    printf >&2 "${P} run ${R}gitui${P} to inspect${R}\n"
    printf >&2 "${P}  the commits about to ship.${R}\n\n"
    jq -n '{
        hookSpecificOutput: {
            hookEventName: "PreToolUse",
            permissionDecision: "ask"
        }
    }'
    exit 0
fi

exit 0
