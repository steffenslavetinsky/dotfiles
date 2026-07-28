#!/usr/bin/env bash
# Logs tool calls that hit friction (denied-by-sandbox / denied-by-user-or-rule /
# error / attempted-unsandboxed) so the sandbox & permission rules can be tuned
# from real data. Plain attempts and successes are dropped — they are the bulk of
# the volume and carry no signal. Wired into PreToolUse, PostToolUse,
# PostToolUseFailure and PermissionDenied by run_after_claude-settings.sh.tmpl.
# Hooks run OUTSIDE the bash sandbox, so writing the log is unaffected by the
# sandbox it reports on.
#
# $1 = hook event name. Reads the hook payload as JSON on stdin.
# Must always exit 0 — a non-zero PreToolUse hook would block the tool.

set -uo pipefail

EVENT="${1:-unknown}"
LOG="${CLAUDE_TOOL_LOG:-$HOME/.claude/logs/tool-outcomes.jsonl}"

MAX_BYTES="${CLAUDE_TOOL_LOG_MAX_BYTES:-$((64 * 1024 * 1024))}"

mkdir -p "$(dirname "$LOG")" 2>/dev/null || true

# Single-backup rotation: unbounded growth made the log unusable once before.
SIZE=$(stat -f%z "$LOG" 2>/dev/null || echo 0)
if (( SIZE > MAX_BYTES )); then
    mv -f "$LOG" "${LOG}.1" 2>/dev/null || true
fi

# One compact line per interesting event. We deliberately do NOT store the full
# payload: tool responses can be huge (whole file reads, long command output),
# which would bloat the log and — because parallel sessions append to the same
# file — risk interleaved partial writes. We keep the derived classification plus
# a short error excerpt that explains *why* a call was denied.
LINE=$(jq -c --arg event "$EVENT" '
  def trunc($n): if . == null then null else (tostring | .[0:$n]) end;
  # Only the output of the tool, never the response envelope: it carries a
  # dangerouslyDisableSandbox field, and matching that would flag every
  # unsandboxed call as sandbox-denied.
  (if (.tool_response | type) == "object"
     then ((.tool_response.stdout // "") + "\n" + (.tool_response.stderr // "") | tostring)
     else (.tool_response // "" | tostring) end) as $resp |
  ($resp | ascii_downcase | test("operation not permitted|by the sandbox|sandbox denied")) as $sandboxish |
  {
    ts: (now | todate),
    event: $event,
    session_id: (.session_id // null),
    cwd: (.cwd // null),
    tool: (.tool_name // null),
    target: (.tool_input.command // .tool_input.file_path // .tool_input.path // .tool_input.pattern // null | trunc(300)),
    unsandboxed: (.tool_input.dangerouslyDisableSandbox // false),
    classification: (
      if $event == "PermissionDenied" then "denied-by-user-or-rule"
      elif $event == "PostToolUseFailure" then (if $sandboxish then "denied-by-sandbox" else "error" end)
      elif $event == "PostToolUse" then (if $sandboxish then "denied-by-sandbox" else "allowed" end)
      elif $event == "PreToolUse" then (if (.tool_input.dangerouslyDisableSandbox // false) then "attempted-unsandboxed" else "attempted" end)
      else "unknown" end
    ),
    detail: (
      if $event == "PermissionDenied" then (.permission_decision_reason // .reason // .message // null | trunc(200))
      elif ($sandboxish or $event == "PostToolUseFailure") then ($resp | .[0:200])
      else null end
    )
  }
  | select(.classification | IN("denied-by-sandbox", "denied-by-user-or-rule", "error", "attempted-unsandboxed"))
  ' 2>/dev/null) || true

# A single write() so concurrent sessions cannot interleave partial lines.
[[ -n "$LINE" ]] && printf '%s\n' "$LINE" >> "$LOG" 2>/dev/null

exit 0
