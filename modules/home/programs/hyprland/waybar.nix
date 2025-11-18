{ host, config, pkgs, lib, ...}:

# What I want in waybar
# - time and date (center ?) ✅
# - music (right ?) ✅
# - cpu modes ❌
# - bluetooth ❌
# - wifi ✅
# - sleep inhibitor ✅
# - ram ✅
# - cpu ✅
# - brightness ✅
# - volume ✅
# - battery ✅

{
config = lib.mkIf config.my.home.programs.hyprland.enable {

    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "top";
                position = "top";
                exclusive = false;
                height = 30;
                spacing = 5;
                modules-left = [ "group/os" "group/media" ];
                modules-center = [ "group/datetime" ];
                modules-right = [ "group/cpuram" "group/tray" "group/system" ];


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

                "group/os" = {
                    orientation = "horizontal";
                    modules = [
                        "custom/openbracket"
                        "custom/nixos"
                        "custom/split"
                        "idle_inhibitor"
                        "custom/closebracket"
                    ];
                };

                "group/media" = {
                    orientation = "horizontal";
                    modules = [
                        "custom/openbracket"
                        "wireplumber"
                        "custom/split"
                        "mpris"
                        "custom/closebracket"
                    ];
                };

                "group/datetime" = {
                    orientation = "horizontal";
                    modules = [
                        "custom/openbracket"
                        "clock"
                        "custom/closebracket"
                    ];
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

                "group/tray" =  {
                    "orientation" =  "horizontal";
                    "modules" =  [
                        "custom/openbracket"
                        "tray"
                        "custom/closebracket"
                    ];
                };

                "group/system" =  {
                    "orientation" =  "horizontal";
                    "modules" =  [
                        "custom/openbracket"
                        "network"
                        "custom/bluetooth"
                        "custom/split"
                        "battery"
                        "backlight"
                        "custom/closebracket"
                    ];
                };

                "clock" =  {
                    "format" = " {0:L%H:%M}";
                    "tooltip-format" = "<big>{:%A, %d.%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
                    "tooltip-delay" = 0;
                };

                "custom/nixos" = {
                    format = "❄️";
                    tooltip = false;
                    on-click = "rofi -show drun";
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

                "cpu" =  {
                    "format" =  " {usage}%";
                    "tooltip" =  false;
                    "interval" =  2;
                    "on-click" =  "kitty -e btop";
                };
                "memory" = {
                    "format" =  " {}%";
                    "tooltip" =  false;
                    "interval" =  2;
                    "on-click" =  "kitty -e btop";
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

        style = ''
            * {
                font-family: "Fira Code";
                font-size: 1rem;
            }

            window#waybar {
                background-color: rgba(0,0,0,0);
            }

            .modules-left {
                background-color: rgba(122, 136, 157, 1);
                border: solid rgba(41, 54, 75, 1);
                border-width: 0 2px 2px 0;
                border-bottom-right-radius: 1rem;
                padding-left: .5rem;
                padding-right: .5rem;
            }

            .modules-right {
                background-color: rgba(122, 136, 157, 1);
                border: solid rgba(41, 54, 75, 1);
                border-width: 0 0 2px 2px;
                border-bottom-left-radius: 1rem;
                padding-left: .5rem;
                padding-right: .5rem;
            }

            .modules-center {
                background-color: rgba(122, 136, 157, 1);
                border: solid rgba(41, 54, 75, 1);
                border-width: 0 2px 2px 2px;
                border-bottom-left-radius: 1rem;
                border-bottom-right-radius: 1rem;
                padding-left: .5rem;
                padding-right: .5rem;
            }

            .module {
                padding-left: .25rem;
                padding-right: .25rem;
            }
        '';
    };
};
}