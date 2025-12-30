#!/usr/bin/env bash

# Usage: ./screenshot.sh [window|output|region]

MODE=$1
DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +'%Y%m%d-%H%M%S%3N')

if [ "$MODE" == "window" ]; then
    # OPTIMIZATION 1: Use text output instead of JSON (-j).
    # OPTIMIZATION 2: Use awk for single-pass extraction.
    CLASS=$(hyprctl activewindow | awk -F ': ' '/class:/ {print $2}')
    
    # Fallback if empty
    [ -z "$CLASS" ] && CLASS="active-window"
    
    # OPTIMIZATION 3: Bash-native replacement (no sed overhead)
    # Replace anything that isn't a letter or number with _
    CLASS=${CLASS//[^a-zA-Z0-9]/_}
    
    FILENAME="${TIMESTAMP}-${CLASS}.png"

elif [ "$MODE" == "output" ]; then
    FILENAME="${TIMESTAMP}-fullscreen.png"

else
    # Region or fallback
    FILENAME="${TIMESTAMP}-region.png"
fi

# Ensure directory exists
mkdir -p "$DIR"

# OPTIMIZATION 4: 'exec' replaces this script process with hyprshot
# This saves memory and creates a seamless transition
exec hyprshot -m "$MODE" -o "$DIR" -f "$FILENAME"
