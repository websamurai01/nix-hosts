#!/usr/bin/env bash

# 1. Get Window State
IS_FLOATING=$(hyprctl activewindow -j | jq -r '.floating')

if [ "$IS_FLOATING" = "false" ]; then
    # --- Tiled -> Floating ---
    
    # 1. Float
    hyprctl dispatch togglefloating
    
    # 2. Resize (75% Width, 95% Height)
    hyprctl dispatch resizeactive exact 70% 95%
    
    # 3. Center
    hyprctl dispatch centerwindow

    # 4. Nudge Down (to sit 8px from bottom)
    #    Current bottom gap is 2.5% of height (because window is 95%).
    #    We calculate: (MonitorHeight * 0.025) - 8px
    
    MON_HEIGHT=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .height / .scale')
    NUDGE_Y=$(awk -v h="$MON_HEIGHT" 'BEGIN { printf "%.0f", (h * 0.025) - 8 }')

    hyprctl dispatch moveactive 0 "$NUDGE_Y"

else
    # --- Floating -> Tiled ---
    hyprctl dispatch togglefloating
fi
