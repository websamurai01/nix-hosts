#!/usr/bin/env bash

FILE="$HOME/.config/fuzzel/folders.txt"

selection=$(awk -F'=' '{print $1}' "$FILE" | fuzzel --dmenu --prompt="Go to: ")

[[ -z "$selection" ]] && exit 0

line=$(rg "^$selection=" "$FILE")

raw_path="${line#*=}"

path="${raw_path/#\~/$HOME}"

thunar "$path"

