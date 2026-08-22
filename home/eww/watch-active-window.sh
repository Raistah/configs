#!/usr/bin/env bash

SOC="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_title() {
  # Get active window title and fallback to empty string if none active
  title=$(hyprctl activewindow -j | jq -r '.title // empty')

  if [ -z "$title" ]; then
    echo ""
  else
    # Truncate long window titles to 40 characters for clean bar alignment
    if [ ${#title} -gt 40 ]; then
      echo "${title:0:37}..."
    else
      echo "$title"
    fi
  fi
}

# Initial state
get_title

# Listen to active window events on Hyprland socket
nc -U "$SOC" | while read -r line; do
  case "$line" in
    activewindow*)
      get_title
      ;;
  esac
done
