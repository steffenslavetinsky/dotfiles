#!/bin/bash
# Intercepts git push to always prompt for user approval (review with gitui first).

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

# "git" (bare, rtk-prefixed or absolute), then any global options such as
# -C <path>, -c <k=v>, --git-dir=<x> or --no-pager, then the verb.
GIT='(^|[^[:alnum:]_-])git([[:space:]]+-[^[:space:]]+([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+'

if [[ "$COMMAND" =~ ${GIT}push([^[:alnum:]_-]|$) ]]; then
    "$HOME/.agent-hooks/gitui-review-gate.sh" push "$SESSION_ID"
    STATUS=$?
    if [[ "$STATUS" -eq 2 ]]; then
        jq -n '{
            hookSpecificOutput: {
                hookEventName: "PreToolUse",
                permissionDecision: "ask"
            }
        }'
        exit 0
    fi
fi

exit 0
