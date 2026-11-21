#!/usr/bin/env bash

FILE="${1:-$HOME/.config/fuzzel/snippets.txt}"

# 1. Initialize an associative array (local to this script only)
declare -A snippets
# 2. Initialize a normal array to keep the original file order
keys=()

# 3. Read the file into memory using only Bash built-ins
while IFS='=' read -r key value || [[ -n "$key" ]]; do
    # Skip empty lines or comments
    [[ -z "$key" || "$key" == \#* ]] && continue

    # Strip the quotes from the value: value="string" -> string
    # %\" removes trailing quote, #\" removes leading quote
    clean_value="${value%\"}"
    clean_value="${clean_value#\"}"

    snippets["$key"]="$clean_value"
    keys+=("$key")
done < "$FILE"

# 4. Feed ONLY the keys from our array to Fuzzel
# This is fast because printf is a shell built-in
selection=$(printf "%s\n" "${keys[@]}" | fuzzel --dmenu --auto-select)

# Exit if Escaped
[[ -z "$selection" ]] && exit 0

# 5. Instant Paste via Clipboard (Faster than wtype character-by-character)
echo -n "${snippets[$selection]}" | wl-copy
wtype -M ctrl v -m ctrl

