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
let 
    waybar_config_path = ".config/waybar/";
    waybar_controler = "waybar_controler.sh";

    waybar_height = 24;
    border-radius = "1rem";
    padding = ".95rem;";
    top = ".1rem;";
    bottom = ".25rem;";
in
{
config = lib.mkIf config.my.home.programs.hyprland.enable {

    home.file."${waybar_config_path}${waybar_controler}" = {
        executable = true;
        text = ''
        STATE_FILE="$HOME/.cache/waybar_mode"

        # Création du fichier si inexistant (mode 0 par défaut)
        if [ ! -f "$STATE_FILE" ]; then
            echo "0" > "$STATE_FILE"
        fi

        WAYBAR_MODE=$(cat "$STATE_FILE")

        # Stopper toutes les instances Waybar proprement
        if pgrep waybar >/dev/null; then
            pkill waybar
            sleep 0.1
        fi

        if [ "$WAYBAR_MODE" = "0" ]; then
            waybar -c ~/.config/waybar/waybar_mini -s ~/.config/waybar/waybar_mini.style.css &
            echo "1" > "$STATE_FILE"
        else
            waybar -c ~/.config/waybar/waybar_medium -s ~/.config/waybar/waybar_medium.style.css &
            echo "0" > "$STATE_FILE"
        fi
        '';
    };

    home.file."${waybar_config_path}waybar_mini" = {
        text = builtins.toJSON {
            layer = "top";
            position = "top";
            exclusive = false;
            height = waybar_height;
            width = 100;
            modules-center = [ "group/mini"  "custom/extend" ];
            
            "group/mini" = {
                orientation = "horizontal";
                modules = [ "clock" ];
            };

            clock =  {
                format = "{:L%H:%M}";
                tooltip-format = "<big>{:%A, %d.%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
                on-click = "bash $HOME/${waybar_config_path}${waybar_controler}";
            };
        };
    };

    home.file."${waybar_config_path}waybar_mini.style.css" = {
        text = ''
            * {
                font-family: "Fira Code";
                font-size: .9rem;
                color: rgba(255,255,255,1);
            }

            window#waybar {
                background-color: rgba(0,0,0,0);
            }

            .modules-center {
                background-color: rgba(0, 0, 0, 1);
                border-bottom-left-radius: ${border-radius};
                border-bottom-right-radius: ${border-radius};
                padding-left: ${padding};
                padding-right: ${padding};
                padding-top: ${top};
                padding-bottom: ${bottom};
            }
        '';
    };

    home.file."${waybar_config_path}waybar_medium" = {
        text = builtins.toJSON {
            layer = "top";
            position = "top";
            exclusive = false;
            height = waybar_height;
            width = 1000;
            modules-left = [ "group/media" ];
            modules-center = [ "group/time" ];

            "custom/sep" = {
                format = " ";
            };
            
            "group/time" = {
                orientation = "horizontal";
                modules = [ "clock" ];
            };

            clock =  {
                format = "{:L%H:%M}";
                tooltip-format = "<big>{:%A, %d.%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
                on-click = "bash $HOME/${waybar_config_path}${waybar_controler}";
            };

            "group/media" = {
                orientation = "horizontal";
                modules = [ "wireplumber" "custom/sep" "mpris" ];
            };

            mpris =  {
                format =  "{status_icon} {dynamic}";
                interval =  1;
                dynamic-len =  40;
                status-icons =  {
                    playing =  "▶";
                    paused =  "⏸";
                    stopped =  "■";
                };
                dynamic-order = ["title"];
            };

            wireplumber =  {
                scroll-step =  5;
                format =  "{icon}{volume}%";
                format-bluetooth =  "{icon}{volume}% ";
                format-bluetooth-muted =  " {icon}";
                format-muted =  "🔇 {volume}%";
                format-icons =  {
                    headphone =  "";
                    hands-free =  "";
                    headset =  "";
                    phone =  "";
                    portable =  "";
                    car =  "";
                    default =  [" " " " " "];
                };
                on-click-right =  "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                on-click =  "pavucontrol";
            };
        };
    };

    home.file."${waybar_config_path}waybar_medium.style.css" = {
        text = ''
            * {
                font-family: "Fira Code";
                font-size: .9rem;
                color: rgba(255,255,255,1);
            }

            window#waybar {
                background-color: rgba(0, 0, 0, 1);
                border-bottom-left-radius: ${border-radius};
                border-bottom-right-radius: ${border-radius};
                padding-top: ${top};
                padding-bottom: ${bottom};
            }

            .modules-left {
                border-bottom-left-radius: ${border-radius};
                padding-left: ${padding};
            }

            .modules-center {
                
            }

            .modules-right {
                border-bottom-right-radius: ${border-radius};
            }

            .module {
                padding-left: .25rem;
                padding-right: .25rem;
            }
        '';
    };

    home.file."${waybar_config_path}waybar_mini_rounded.style.css" = {
        text = ''
            * {
                font-family: "Fira Code";
                font-size: 1rem;
            }

            window#waybar {
                background-color: rgba(0,0,0,0);
            }

            .modules-center {
                background-color: rgba(0, 0, 0, 1);
                color: rgba(255,255,255,1);
                border-radius: 1rem;
                margin-top: .25rem;
                padding-left: 1rem;
                padding-right: 1rem;
            }
        '';
    };

    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                ipc = true;
                id = "1";
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