{ host, config, pkgs, lib, ...}:

let 
    waybar_config_path = ".config/waybar/";
    waybar_controler = "waybar_controler.sh";

    waybar_height = 24;
    mini_width = 100;
    medium_width = 1000;

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
            echo "mini" > "$STATE_FILE"
            waybar -c ~/.config/waybar/waybar_mini -s ~/.config/waybar/waybar_mini.style.css &
        else

            WAYBAR_MODE=$(cat "$STATE_FILE")

            ACTION=""
            if [ $# -eq 1 ] && [ "$1" = "big" ]; then
                ACTION="big"
            elif [ $# -eq 1 ] && [ "$1" = "kill" ]; then
                ACTION="kill"
            fi

            echo "Action: $ACTION"
            echo "\$1: $1"

            if [ "$ACTION" = "kill" ]; then
                if pgrep waybar >/dev/null; then
                    pkill waybar
                    case "$WAYBAR_MODE" in
                        "mini")
                            echo "killed_mini" > "$STATE_FILE"
                            ;;
                        "medium")
                            echo "killed_medium" > "$STATE_FILE"
                            ;;
                        "full_mini")
                            echo "killed_full_mini" > "$STATE_FILE"
                            ;;
                        "full_medium")
                            echo "killed_full_medium" > "$STATE_FILE"
                            ;;
                        *)
                            echo "killed_mini" > "$STATE_FILE"
                            ;;
                    esac
                fi
            else
                if pgrep waybar >/dev/null; then
                    pkill waybar
                    sleep 0.1
                fi

                if [ "$ACTION" = "big" ]; then
                    case "$WAYBAR_MODE" in
                        "mini" | "killed_full_mini" | "killed_mini")
                            waybar -c ~/.config/waybar/waybar_full -s ~/.config/waybar/waybar_full.style.css &
                            echo "full_mini" > "$STATE_FILE"
                            ;;
                        "medium" | "killed_full_medium" | "killed_medium")
                            waybar -c ~/.config/waybar/waybar_full -s ~/.config/waybar/waybar_full.style.css &
                            echo "full_medium" > "$STATE_FILE"
                            ;;
                        "full_mini")
                            waybar -c ~/.config/waybar/waybar_mini -s ~/.config/waybar/waybar_mini.style.css &
                            echo "mini" > "$STATE_FILE"
                            ;;
                        "full_medium")
                            waybar -c ~/.config/waybar/waybar_medium -s ~/.config/waybar/waybar_medium.style.css &
                            echo "medium" > "$STATE_FILE"
                            ;;
                        *)
                            waybar -c ~/.config/waybar/waybar_mini -s ~/.config/waybar/waybar_mini.style.css &
                            echo "mini" > "$STATE_FILE"
                            ;;
                    esac
                else
                    case "$WAYBAR_MODE" in
                        "mini" | "full_medium" | "killed_medium" | "killed_full_medium")
                            waybar -c ~/.config/waybar/waybar_medium -s ~/.config/waybar/waybar_medium.style.css &
                            echo "medium" > "$STATE_FILE"
                            ;;
                        "medium" | "full_mini" | "killed_mini" | "killed_full_mini")
                            waybar -c ~/.config/waybar/waybar_mini -s ~/.config/waybar/waybar_mini.style.css &
                            echo "mini" > "$STATE_FILE"
                            ;;
                        *)
                            waybar -c ~/.config/waybar/waybar_mini -s ~/.config/waybar/waybar_mini.style.css &
                            echo "mini" > "$STATE_FILE"
                            ;;
                    esac
                fi
            fi
        fi
        '';
    };

    home.file."${waybar_config_path}waybar_mini" = {
        text = builtins.toJSON {
            layer = "top";
            position = "top";
            exclusive = false;
            height = waybar_height;
            width = mini_width;
            modules-center = [ "group/mini"  "custom/extend" ];
            
            "group/mini" = {
                orientation = "horizontal";
                modules = [ "clock" ];
            };

            clock =  {
                format = "{:L%H:%M}";
                tooltip-format = "<big>{:%A, %d.%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
                on-click = "bash $HOME/${waybar_config_path}${waybar_controler}";
                on-click-middle = "bash $HOME/${waybar_config_path}${waybar_controler} big";
                on-click-right = "bash $HOME/${waybar_config_path}${waybar_controler} kill";
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
            width = medium_width;
            modules-left = [ "group/media" ];
            modules-center = [ "group/time" ];
            modules-right = [ "group/system" ];

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
                on-click-middle = "bash $HOME/${waybar_config_path}${waybar_controler} big";
                on-click-right = "bash $HOME/${waybar_config_path}${waybar_controler} kill";
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

            "group/system" = {
                orientation = "horizontal";
                modules = [ "group/cpuram" "custom/sep" "tray" "custom/sep" "group/controls" ];
            };

            "group/cpuram" =  {
                "orientation" =  "horizontal";
                "modules" =  [
                    "cpu"
                    "memory"
                ];
            };

            "group/controls" =  {
                "orientation" =  "horizontal";
                "modules" =  [
                    "battery"
                    "backlight"
                    "idle_inhibitor"
                ];
            };

            "idle_inhibitor" =  {
                "format" =  "{icon}";
                "format-icons" =  {
                    "activated" =  "☕";
                    "deactivated" =  "🛏️";
                };
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

            "backlight" =  {
                "format" =  "{icon} {percent}%";
                "format-icons" =  ["🌙" "" ""];
            };

            "battery" =  {
                "states" =  {
                    "warning" =  30;
                    "critical" =  15;
                };
                "format" =  "{icon} {capacity}%";
                "format-full" =  "{icon} {capacity}%";
                "format-charging" =  " {capacity}%";
                "format-plugged" =  " {capacity}%";
                "format-icons" =  ["" "" "" "" ""];
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
                background-color: rgba(0, 0, 0, 0.99);
                border-bottom-left-radius: ${border-radius};
                border-bottom-right-radius: ${border-radius};
                padding-top: ${top};
                padding-bottom: ${bottom};
            }

            .modules-left {
                background-color: rgba(0, 0, 0, 1);
                border-bottom-left-radius: ${border-radius};
                padding-left: ${padding};
            }

            .modules-center {
                background-color: rgba(0, 0, 0, 1);
            }

            .modules-right {
                background-color: rgba(0, 0, 0, 1);
                border-bottom-right-radius: ${border-radius};
                padding-right: ${padding};
            }

            .module {
                padding-left: .25rem;
                padding-right: .25rem;
            }
        '';
    };

    home.file."${waybar_config_path}waybar_full" = {
        text = builtins.toJSON {
            layer = "top";
            position = "top";
            height = waybar_height;
            modules-left = [ "group/media" ];
            modules-center = [ "group/time" ];
            modules-right = [ "group/system" ];

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
                on-click-middle = "bash $HOME/${waybar_config_path}${waybar_controler} big";
                on-click-right = "bash $HOME/${waybar_config_path}${waybar_controler} kill";
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
                dynamic-order = ["title" "artist"];
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

            "group/system" = {
                orientation = "horizontal";
                modules = [ "group/cpuram" "custom/sep" "tray" "custom/sep" "group/controls" ];
            };

            "group/cpuram" =  {
                "orientation" =  "horizontal";
                "modules" =  [
                    "cpu"
                    "memory"
                ];
            };

            "group/controls" =  {
                "orientation" =  "horizontal";
                "modules" =  [
                    "battery"
                    "backlight"
                    "idle_inhibitor"
                ];
            };

            "idle_inhibitor" =  {
                "format" =  "{icon}";
                "format-icons" =  {
                    "activated" =  "☕";
                    "deactivated" =  "🛏️";
                };
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

            "backlight" =  {
                "format" =  "{icon} {percent}%";
                "format-icons" =  ["🌙" "" ""];
            };

            "battery" =  {
                "states" =  {
                    "warning" =  30;
                    "critical" =  15;
                };
                "format" =  "{icon} {capacity}%";
                "format-full" =  "{icon} {capacity}%";
                "format-charging" =  " {capacity}%";
                "format-plugged" =  " {capacity}%";
                "format-icons" =  ["" "" "" "" ""];
            };
        };
    };

    home.file."${waybar_config_path}waybar_full.style.css" = {
        text = ''
            * {
                font-family: "Fira Code";
                font-size: .9rem;
                color: rgba(255,255,255,1);
            }

            window#waybar {
                background-color: rgba(0, 0, 0, 1);
                padding-top: ${top};
                padding-bottom: ${bottom};
            }

            .modules-left {
                background-color: rgba(0, 0, 0, 1);
                padding-left: ${padding};
            }

            .modules-center {
                background-color: rgba(0, 0, 0, 1);
            }

            .modules-right {
                background-color: rgba(0, 0, 0, 1);
                padding-right: ${padding};
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

    programs.waybar.enable = true;
};
}