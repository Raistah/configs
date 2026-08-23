#!/usr/bin/env bash

# Function to query current layout on startup
get_layout() {
  hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | cut -c 1-2 | tr '[:lower:]' '[:upper:]'
}

# Print initial layout on script launch
get_layout


SOC="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Listen to Hyprland's event socket
nc -U "$SOC" | while read -r line; do
  case "$line" in
    activelayout*)
      # Extract active layout name from event string "activelayout>>keyboard_name,Layout Name"
      echo "$line" | awk -F',' '{print $2}' | cut -c 1-2 | tr '[:lower:]' '[:upper:]'
      ;;
  esac
done
