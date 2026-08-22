#!/usr/bin/env bash

get_workspaces_json() {
    MONITORS=$(hyprctl monitors -j)
    WORKSPACES=$(hyprctl workspaces -j)

    jq -c -n \
        --argjson mons "$MONITORS" \
        --argjson wss "$WORKSPACES" '
        ($mons | map({key: .name, value: {active: .activeWorkspace.id, id: .id}}) | from_entries) as $mon_map |

        $wss
        | group_by(.monitor)
        | map({
            key: .[0].monitor,
            value: (
                map({
                    id: .id,
                    name: .name,
                    is_active: (.id == $mon_map[.monitor].active)
                }) | sort_by(.id)
            )
        })
        | from_entries
    '
}

# Output initial state
get_workspaces_json

SOC="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Stream live updates on workspace events
nc -U "$SOC" | while read -r line; do
    case "$line" in
        workspace*|focusedmon*|createworkspace*|destroyworkspace*|moveworkspace*)
            get_workspaces_json
            ;;
    esac
done
