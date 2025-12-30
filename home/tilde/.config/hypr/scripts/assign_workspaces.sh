#!/bin/bash

# Wait a bit for Hyprland to fully initialize
sleep 2

# Create and assign workspaces to monitors by switching to each one
hyprctl dispatch workspace 1
hyprctl dispatch moveworkspacetomonitor 1 DP-1

hyprctl dispatch workspace 2
hyprctl dispatch moveworkspacetomonitor 2 DP-1

hyprctl dispatch workspace 3
hyprctl dispatch moveworkspacetomonitor 3 DP-1

hyprctl dispatch workspace 4
hyprctl dispatch moveworkspacetomonitor 4 HDMI-A-1

hyprctl dispatch workspace 5
hyprctl dispatch moveworkspacetomonitor 5 HDMI-A-1

hyprctl dispatch workspace 6
hyprctl dispatch moveworkspacetomonitor 6 HDMI-A-1

# Switch back to workspace 1 on the primary monitor
hyprctl dispatch workspace 1
