#!/usr/bin/env bash

get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%'
}

get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@
}

get_text() {
    if [[ "$(get_mute)" == "Mute: yes" ]]; then
        echo "󰝟"
    else
        vol_num=$(get_volume)
        vol_num=${vol_num:-0}

        if [ "$vol_num" -eq 0 ]; then
            icon="󰕿"
        elif [ "$vol_num" -lt 40 ]; then
            icon="󰖀"
        else
            icon="󰕾"
        fi

        echo "$icon  ${vol_num}%"
    fi
}

# Print initial state
get_text

# Listen for sink changes efficiently in real-time
pactl subscribe | grep --line-buffered "change.*sink" | while read -r _; do
    get_text
done
