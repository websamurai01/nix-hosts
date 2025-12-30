#!/bin/bash

# Get workspace information using hyprctl
workspaces_info=$(hyprctl workspaces -j)

# Parse the JSON and create output for each workspace
echo "$workspaces_info" | jq -r '.[] | "workspace_\(.id): \(.windows)"' | while read -r line; do
    workspace_id=$(echo "$line" | cut -d: -f1)
    window_count=$(echo "$line" | cut -d: -f2 | xargs)
    
    # Set the variable for this specific workspace
    export "$workspace_id"="$window_count"
done

# Output just the count for the current workspace
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
current_count=$(echo "$workspaces_info" | jq -r ".[] | select(.id == $current_workspace) | .windows")

echo "{\"text\":\"$current_count\", \"tooltip\":\"Window count for current workspace\"}"
