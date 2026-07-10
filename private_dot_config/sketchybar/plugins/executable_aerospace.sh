#!/usr/bin/env bash
# Workspace indicator. $1 = the workspace id this item represents.
# Draws the item only when its workspace is focused OR non-empty.
# On aerospace_workspace_change, $FOCUSED_WORKSPACE holds the newly focused id;
# at load time (--update) it is unset, so fall back to querying AeroSpace.

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
NON_EMPTY="$(aerospace list-workspaces --monitor all --empty no)"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" drawing=on \
                           background.drawing=on \
                           label.color=0xffffffff
elif echo "$NON_EMPTY" | grep -qx "$SID"; then
  sketchybar --set "$NAME" drawing=on \
                           background.drawing=off \
                           label.color=0xff888888
else
  sketchybar --set "$NAME" drawing=off
fi
