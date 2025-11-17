{ pkgs, ... }:
pkgs.writeShellScriptBin "waybar-on-special-ws" ''
    SPECIAL="special:special"

    get_special_workspace() {
        hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .specialWorkspace.name'
    }

    ws_name=$(get_special_workspace)
    if [ "$ws_name" = "$SPECIAL" ]; then
        if [ "$(pidof waybar)" != "" ]; then
            pkill waybar
        fi
        waybar
    else
        if [ "$(pidof waybar)" != "" ]; then
            pkill waybar
        fi
    fi
    ''