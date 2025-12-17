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

            output = {
                    _args = [ "Virtual-1" ];
                    mode = "3840x2160@59.940";
                    scale = 2;
                    transform = "normal";
                    #position = { x = 1280; y = 0; };
            };

            layout = {
                gaps = 4;
                struts = {
                    left = 64;
                    right = 64;
                #    top = 16;
                #    bottom = 16;
                };
                center-focused-column = "never";
                #default-column-display = "tabbed";
                empty-workspace-above-first = no-children;
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

            window-rule = {
                geometry-corner-radius = 12;
                clip-to-geometry = true;
            };

            spawn-sh-at-startup = "$HOME/.config/waybar/waybar-controler.sh init";
            hotkey-overlay = { skip-at-startup = no-children; };
            prefer-no-csd = no-children;

            screenshot-path = "~/download/screenshots/screenshot from %Y-%m-%d %H-%M-%S.png";
            #animation = {};
        });
    };
}