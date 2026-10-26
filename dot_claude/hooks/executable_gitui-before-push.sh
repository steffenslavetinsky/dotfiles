#!/bin/bash
# Intercepts git push to always prompt for user approval (review with gitui first).

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

# Opt-out per repo: a .yolo file in the repo root skips the gate for commit and push.
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
[[ -f "$ROOT/.yolo" ]] && exit 0

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
