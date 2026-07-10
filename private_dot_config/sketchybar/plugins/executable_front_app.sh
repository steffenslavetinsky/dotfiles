#!/usr/bin/env bash
# Focused-application name. Subscribed to front_app_switched.

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
fi
