{ lib, config, pkgs, nixosConfig, ...}:
let 
    # Use a custom implementation of the lib.hm.generators.toKDL function
    toKDL = (import ./toKDL.nix { inherit lib; } ).toKDL;
    #toKdl = lib.hm.generators.toKDL;
    no-children = { "_no-children" = true; };
in 
{
    options.my.home.programs.niri.enable = lib.mkEnableOption "Enable my niri ecosystem";

    config = lib.mkIf config.my.home.programs.niri.enable {
        my.home.programs.mako.enable = true;
        my.home.programs.rofi.enable = true;
        my.home.programs.rofimoji.enable = true;
        my.home.programs.waybar.enable = true;
        my.home.programs.hyprpaper.enable = true;
        my.home.programs.hyprlock.enable = true;
        my.home.scripts.niri-media-switcher.enable = true;

        assertions =
        [ { assertion = nixosConfig.programs.niri.enable;
            message = "programs.niri.enable must be set to `true` on system level for niri to work";
            }
        ];

        home.packages = with pkgs; [
            xwayland-satellite # xwayland support
            alacritty
        ];

        home.file.".config/niri/config.kdl".text = toKDL
        ((import ./binds.nix) //
        {
            input = {
                keyboard = {
                    xkb = {
                        layout = "fr";
                    };
                    numlock = no-children;
                };
                touchpad = {
                    tap = no-children;
                    natural-scroll = no-children;
                };
                mouse = {};
                trackpoint = {};
                #focus-follows-mouse = no-children;
            };

            output = [ 
                {
                    _args = [ "Virtual-1" ];
                    mode = "3840x2160@59.940";
                    scale = 2;
                    transform = "normal";
                    #position = { x = 1280; y = 0; };
                } 
                {
                    _args = [ "eDP-1" ];
                    mode = "3200x2000@120.000";
                    scale = 2;
                    transform = "normal";
                    position = { _props = { x = 0; y = 0; }; };
                } 
                {
                    _args = [ "HDMI-A-1" ];
                    mode = "2560x1440@143.972";
                    scale = 1;
                    transform = "normal";
                    position = { _props = { x = 1600; y = -400; }; };
                }
            ];

            layout = {
                gaps = 2;
                struts = {
                    left = 32;
                    right = 32;
                    top = -2;
                    bottom = -2;
                };
                center-focused-column = "never";
                #default-column-display = "tabbed";
                #empty-workspace-above-first = no-children;
                always-center-single-column = no-children;
                preset-column-widths = {
                    proportion = [
                        0.33333
                        0.5
                        0.66667
                    ];
                };
                default-column-width = { proportion = 0.5; };
                focus-ring = {
                    off = no-children;
                    width = 4;
                    active-color = "#7fc8ff";
                    inactive-color = "#505050";
                };
                border = {
                    # It is not a good idea to enable the focus-ring and the border
                    #off = no-children;
                    width = 1;
                    active-color = "#ffc87f";
                    inactive-color = "#505050";
                    urgent-color = "#9b0000";
                };     
                shadow = {
                    on = no-children;
                    softness = 30;
                    spread = 5;
                    offset = { _props = {x=0; y=5;}; };
                    color = "#0007";
                };
                tab-indicator = {
                    # off
                    hide-when-single-tab = no-children;
                    place-within-column = no-children;
                    gap = 2;
                    width = 8;
                    length = { _props={total-proportion=1.0; };};
                    position = "right";
                    gaps-between-tabs = 2;
                    corner-radius = 8;
                    #active-color = "red";
                    #inactive-color = "gray";
                    #urgent-color = "blue";
                    active-gradient =   { _props = { from="#ffb14aff"; to="#ff9100ff"; angle=0; }; };
                    inactive-gradient = { _props = { from="#505050"; to="#808080"; angle=0; relative-to="workspace-view"; }; };
                    urgent-gradient =   { _props = { from="#800"; to="#aa339aff"; angle=0; }; };
                };
                insert-hint = {
                    off = no-children;
                    #color "#ffc87f80"
                };
            };

            gestures = {
                hot-corners = { off = no-children; };
            };

            environment = {
                "NIXOS_OZONE_WL" = "1";
                "NIXPKGS_ALLOW_UNFREE" = "1";
                "XDG_CURRENT_DESKTOP" = "Hyprland";
                "XDG_SESSION_TYPE" = "wayland";
                "XDG_SESSION_DESKTOP" = "Hyprland";
                "GDK_BACKEND" = "wayland,x11";
                "CLUTTER_BACKEND" = "wayland";
                "QT_QPA_PLATFORM" = "wayland;xcb";
                "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
                "QT_AUTO_SCREEN_SCALE_FACTOR" = "1";
                "SDL_VIDEODRIVER" = "x11";
                "MOZ_ENABLE_WAYLAND" = "1";
                # This is to make electron apps start in wayland
                "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
                # Disabling this by default as it can result in inop cfg
                # Added card2 in case this gets enabled. For better coverage
                # This is mostly needed by Hybrid laptops.
                # but if you have multiple discrete GPUs this will set order
                #"AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1:/dev/card2"
                "GDK_SCALE"= "1";
                "QT_SCALE_FACTOR"= "1";
                # Set terminal and xdg_terminal_emulator to kitty
                # To provent yazi from starting xterm when run from rofi menu
                # You can set to your preferred terminal if you you like
                "TERMINAL" = "kitty";
                "XDG_TERMINAL_EMULATOR" = "kitty";
                "XDG_MENU_PREFIX" = "plasma-";
            };

            window-rule = [ 
                {
                    geometry-corner-radius = 12;
                    clip-to-geometry = true;
                }
                {
                    match = [ 
                        { _props={app-id="^obsidian$";}; } 
                        { _props={app-id="^spotify$";}; }
                        { _props={app-id="beepertexts";}; } # BEEPER DOES NOT BEHAVE GRRRR 
                    ];
                    open-on-workspace = "media";
                }
                {
                    match = [ 
                        { _props={app-id="code$";}; } 
                        { _props={app-id="obsidian$";}; } 
                        { _props={app-id=''r#"^app\.zen_browser\.zen$"#'';}; } 
                    ];
                    open-maximized = true;
                }
            ];

            spawn-sh-at-startup = [
                "$HOME/.config/waybar/waybar-controler.sh init"
                "systemctl --user restart hypridle.service"
                "systemctl --user restart hyprpaper.service"
                "systemctl --user restart caffeine"
                "systemctl --user restart udiskie"
                "beeper" # For some reason I cannot find a way to spawn beeper from regular 'spawn' 
                "nm-applet --indicator"
                "blueman-applet"
            ];
            spawn-at-startup = [
                "obsidian" "spotify"
            ];
            hotkey-overlay = { skip-at-startup = no-children; };
            prefer-no-csd = no-children;

            workspace = [ 
                {   _args = [ "media" ]; 
                    open-on-output = "eDP-1";
                } 
            ];


            screenshot-path = "~/download/screenshots/screenshot from %Y-%m-%d %H-%M-%S.png";
            #animation = {};
        });
    };
}