#!/usr/bin/env bash
# System volume + Nerd Font icon. Subscribed to volume_change ($INFO = 0-100).

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾" ;;
    [3-5][0-9])     ICON="󰖀" ;;
    [1-9]|[1-2][0-9]) ICON="󰕿" ;;
    *) ICON="󰝟" ;;
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
fi
