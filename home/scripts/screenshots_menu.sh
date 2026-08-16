#!/usr/bin/env bash
items="Monitor sreenshot\nWindow sreenshot\nRegion sreenshot"
output=$(echo -e $items | walker --dmenu)
if [[ $output == "Monitor sreenshot" ]]; then
    hyprshot -m active -m output --clipboard-only
elif [[ $output == "Window sreenshot" ]]; then
    hyprshot -m window --clipboard-only
elif [[ $output == "Region sreenshot" ]]; then
    hyprshot -m region --clipboard-only
fi
