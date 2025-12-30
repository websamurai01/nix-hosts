#!/usr/bin/env bash

# Get the active special workspace name on the focused monitor
# Returns something like "special:notes", "special:music", or empty string
active_special=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .specialWorkspace.name | select(. != "")')

if [ -n "$active_special" ]; then
    # Strip "special:" prefix (e.g., "special:notes" -> "notes")
    clean_name=${active_special#special:}
    
    # Toggle it off
    hyprctl dispatch togglespecialworkspace "$clean_name"
fi
