{ pkgs, lib, option, config, system, ... }:
let
script = pkgs.writeShellScriptBin "waybar-on-special-ws" ''
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
    '';
in
{
    options.my.home.scripts.waybar-on-special-ws.enable = lib.mkEnableOption "Enable the waybar-on-special-ws script";

	config = lib.mkIf config.my.home.scripts.waybar-on-special-ws.enable {
		home.packages = [script];
	};
}