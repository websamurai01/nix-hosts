#!/usr/bin/env bash

# Define the options
OPTIONS="󰒲  Sleep\n󰑓  Reboot\n󰐥  Shutdown\n󰗼  Logout"

# Pass options to fuzzel in dmenu mode
# We use --lines 4 to match the number of options exactly
SELECTION=$(echo -e "$OPTIONS" | fuzzel --dmenu --prompt="> " --lines 4 --width 32)

case "$SELECTION" in
    *Sleep)
        systemctl suspend
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
    *Logout)
        hyprctl dispatch exit
        ;;
esac

