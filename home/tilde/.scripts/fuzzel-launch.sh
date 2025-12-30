#!/usr/bin/env bash

FILE="$HOME/.config/fuzzel/launch.txt"

selection=$(awk -F'=' '{print $1}' "$FILE" | fuzzel --dmenu --auto-select --prompt=": ")

[[ -z "$selection" ]] && exit 0

line=$(rg "^$selection=" "$FILE")

exec="${line#*=}"

$exec
