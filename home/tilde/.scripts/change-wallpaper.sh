#!/usr/bin/env bash

# 1. Input Sanitization
# Thunar sometimes passes paths wrapped in quotes (e.g. '/path/to/file')
# We strip them so readlink can find the actual file.
CLEAN_PATH="$1"
CLEAN_PATH="${CLEAN_PATH#\'}"
CLEAN_PATH="${CLEAN_PATH%\'}"
CLEAN_PATH="${CLEAN_PATH#\"}"
CLEAN_PATH="${CLEAN_PATH%\"}"

# 2. Get Absolute Path
IMAGE=$(readlink -f "$CLEAN_PATH")

# 3. Validate
if [ -z "$IMAGE" ] || [ ! -f "$IMAGE" ]; then
    notify-send "Wallpaper Error" "Image not found."
    exit 1
fi

# 4. Apply Wallpaper
swww img "$IMAGE" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-fps 60 \
    --transition-duration 1

# 5. Notify
notify-send "Wallpaper Changed" "$(basename "$IMAGE")"

