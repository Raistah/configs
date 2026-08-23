#!/usr/bin/env bash

AUDIO_STATE_FILE="/tmp/eww_rec_audio"
STATUS_FILE="/tmp/eww_rec_status"
OUT_DIR="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Videos")"
mkdir -p "$OUT_DIR"
TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
OUTPUT_FILE="${OUT_DIR}/screen_recording_${TIMESTAMP}.mp4"

# Handle stop request
if [ "$1" = "stop" ] || pgrep -x "wf-recorder" > /dev/null; then
    killall -INT wf-recorder 2>/dev/null
    rm -f "$STATUS_FILE"
    eww update rec_status=false
    notify-send "Screen Recorder" "Recording stopped and saved to ${OUT_DIR}"
    exit 0
fi

MODE="${1:-region}"
AUDIO_FLAG=""

if [ -f "$AUDIO_STATE_FILE" ] && [ "$(cat "$AUDIO_STATE_FILE")" = "true" ]; then
    AUDIO_FLAG="--audio"
fi

# Close the eww menu immediately
eww close recorder_menu 2>/dev/null

# Function to spawn process safely away from parent subshell
record_geometry() {
    local geom="$1"
    if [ -n "$geom" ]; then
        wf-recorder $AUDIO_FLAG -g "$geom" -f "$OUTPUT_FILE" >/dev/null 2>&1
    fi
}

case "$MODE" in
    region)
        GEOM=$(slurp) || exit 1
        record_geometry "$GEOM" &
        ;;
    window)
        GEOM=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == '$(hyprctl activeworkspace -j | jq .id)') | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp) || exit 1
        record_geometry "$GEOM" &
        ;;
    screen)
        wf-recorder $AUDIO_FLAG -f "$OUTPUT_FILE" >/dev/null 2>&1 &
        ;;
esac

echo "true" > "$STATUS_FILE"
eww update rec_status=true
notify-send "Screen Recorder" "Started recording..."
