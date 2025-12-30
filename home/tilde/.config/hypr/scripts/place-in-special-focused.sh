#!/usr/bin/env bash

# 1. Get current workspace information
# We check if the window is already in the special workspace named "special:focused"
CURRENT_WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.name')

if [ "$CURRENT_WORKSPACE" != "special:focused" ]; then
    # --- Normal -> Focus Mode ---
    hyprctl dispatch movetoworkspace special:focused

    hyprctl dispatch togglefloating

    hyprctl dispatch resizeactive exact 70% 95%

    hyprctl dispatch centerwindow

    MON_HEIGHT=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .height / .scale')
    NUDGE_Y=$(awk -v h="$MON_HEIGHT" 'BEGIN { printf "%.0f", (h * 0.025) - 8 }')

    hyprctl dispatch moveactive 0 "$NUDGE_Y"

else
    # --- Focus Mode -> Normal ---
    hyprctl dispatch movetoworkspace m+0

    hyprctl dispatch togglefloating

fi
