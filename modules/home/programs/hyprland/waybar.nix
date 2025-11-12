{ host, config, pkgs, lib, ...}:

# What I want in waybar
# - time and date (center ?)
# - music (right ?)
# - cpu modes
# - bluetooth
# - wifi
# - sleep inhibitor
# - ram
# - cpu
# - brightness
# - volume
# - battery
# Left -> System
# Center -> Time, date, weather ?
# Right -> Media & tray

{
config = lib.mkIf config.my.home.programs.hyprland.enable {

    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "top";
                position = "top";
                exclusive = false;
                height = 40;
                spacing = 5;
                modules-left = [ "group/" "group/systeminfo" "group/wifibluetooth" ];
                # modules-left = [ "group/Utilities" "group/workspaces" "group/brightvol" "mpris" ];
                modules-center = [ "group/datetime" ];
                modules-right = [ "group/cpuram" "group/system" ];


                "custom/openbracket" = {
                    format = "[";
                    tooltip = false;
                };
                "custom/closebracket" = {
                    format = "]";
                    tooltip = false;
                };
                "custom/split" = {
                    format = "|";
                    tooltip = false;
                };

                "group/datetime" = {
                    orientation = "horizontal";
                    modules = [
                        "custom/openbracket"
                        "clock"
                        "custom/closebracket"
                    ];
                };

                "clock" =  {
                    "format" =  "{0:%a, %d %b} | {0:L%H:%M}";
                    "tooltip-format" =  "<big>{:%A, %d.%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
                };

                "group/Utilities" = {
                    orientation = "horizontal";
                    modules = [
                        "custom/openbracket"
                        "custom/nixos"
                        "custom/split"
                        "idle_inhibitor"
                        "custom/closebracket"
                    ];
                };

                "custom/nixos" = {
                    format = "❄️";
                    tooltip = false;
                    on-click = "rofi -show drun";
                };

                "group/workspaces" = {
                    "orientation" =  "horizontal";
                    "modules" = [
                        "custom/openbracket"
                        "hyprland/workspaces"
                        "custom/closebracket"
                    ];
                };

                "hyprland/workspaces" =  {
                    "all-outputs" =  true;
                    "warp-on-scroll" =  false;
                    "enable-bar-scroll" =  true;
                    "disable-scroll-wraparound" =  true;
                    "active-only" =  false;
                    "format" =  "{icon}";
                    "format-icons" =  {
                        "1" =  "1";
                        "2" =  "2";
                        "3" =  "3";
                        "4" =  "4";
                        "5" =  "5";
                        "6" =  "6";
                        "default" =  "•";
                    };
                };

                "idle_inhibitor" =  {
                    "format" =  "{icon}";
                    "format-icons" =  {
                        "activated" =  "☕";
                        "deactivated" =  "🛏️";
                    };
                };

                "mpris" =  {
                    "format" =  "[ ♫ {status_icon} | {dynamic} ]";
                    "interval" =  1;
                    "dynamic-len" =  40;
                    "status-icons" =  {
                        "playing" =  "▶";
                        "paused" =  "⏸";
                        "stopped" =  "■";
                    };
                    "dynamic-order" =  ["artist"];
                };

                "group/windows" =  {
                    "orientation" = "horizontal";
                    "modules" = [
                        "custom/openbracket"
                        "hyprland/window"
                        "custom/closebracket"
                    ];
                };
                "hyprland/window" =  {
                    "format" =  "{title}"; 
                    "max-length" =  20;
                    "min-length" =  0;
                    "all-outputs" =  true;
                };

                "group/cpuram" =  {
                    "orientation" =  "horizontal";
                    "modules" =  [
                        "custom/openbracket"
                        "cpu"
                        "custom/split"
                        "memory"
                        "custom/closebracket"
                    ];
                };
                "cpu" =  {
                    "format" =  "CPU = {usage}%";
                    "tooltip" =  false;
                    "interval" =  2;
                    "on-click" =  "kitty -e btop";
                };
                "memory" = {
                    "format" =  "RAM = {}%";
                    "tooltip" =  false;
                    "interval" =  2;
                    "on-click" =  "kitty -e btop";
                };

                "group/brightvol" =  {
                    "orientation" =  "horizontal";
                    "modules" =  [
                        "custom/openbracket"
                        "backlight"
                        "custom/split"
                        "wireplumber"
                        "custom/closebracket"
                    ];
                };

                "wireplumber" =  {
                    "scroll-step" =  5;
                    "format" =  "{icon}{volume}%";
                    "format-bluetooth" =  "{icon}{volume}% ";
                    "format-bluetooth-muted" =  " {icon}";
                    "format-muted" =  "";
                    "format-icons" =  {
                        "headphone" =  "";
                        "hands-free" =  "";
                        "headset" =  "";
                        "phone" =  "";
                        "portable" =  "";
                        "car" =  "";
                        "default" =  ["  = " "  = " "  = "];
                    };
                    "on-click" =  "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                    "on-click-right" =  "pavucontrol";
                };
                "backlight" =  {
                    "format" =  "{icon} = {percent}%";
                    "format-icons" =  ["" "" "🌙"];
                    "on-click" =  "~/.config/waybar/scripts/brightness_slider.sh";
                };

                "group/system" =  {
                    "orientation" =  "horizontal";
                    "modules" =  [
                        "custom/openbracket"
                        "clock"
                        "custom/split"
                        "network"
                        "custom/bluetooth"
                        "custom/clipboard"
                        "battery"
                        "custom/closebracket"
                    ];
                };
                
                "custom/clipboard" =  {
                    "format" =  "";
                    "tooltip" =  false;
                    "on-click" =  "~/.config/waybar/scripts/clipboard_menu.sh";
                };
                "battery" =  {
                    "states" =  {
                        "warning" =  30;
                        "critical" =  15;
                    };
                    "format" =  "{icon} {capacity}%";
                    "format-full" =  "{icon} {capacity}%";
                    "format-charging" =  " {capacity}%";
                    "format-plugged" =  "  {capacity}%";
                    "format-icons" =  ["" "" "" "" ""];
                    "on-click" =  "wlogout";
                };

                "network" =  {
                    "interface" =  "wlan0";
                    "format-wifi" =  "{icon}";
                    "format-ethernet" =  "󰈀 LAN";
                    "format-disconnected" =  "󰖪";
                    "tooltip-format" =  "{ipaddr}\n{ssid} ({signalStrength}%)";
                    "on-click" =  "kitty -e nmtui";
                    "format-icons" =  [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
                };
                
                "custom/bluetooth" =  {
                    "format" =  "{}";
                    "exec" =  "~/.config/waybar/scripts/bluetooth_status.sh";
                    "interval" =  5;
                    "on-click" =  "blueman-manager";
                };
            };
        };
    };
};
}