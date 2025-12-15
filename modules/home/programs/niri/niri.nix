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
            };

            output = {
                    _args = [ "eDP-1" ];
                    mode = "3200x2000@120.030";
                    scale = 2;
                    transform = "normal";
                    #position = { x = 1280; y = 0; };
            };

            layout = {
                gaps = 16;
                center-focused-column = "never";
                #preset-column-widths = [
                #    { proportion = 0.33333; }
                #    { proportion = 0.5; }
                #    { proportion = 0.66667; }
                #];
                default-column-width = { proportion = 0.5; };
                focus-ring = {
                    width = 4;
                    active-color = "#7fc8ff";
                    inactive-color = "#505050";
                };
                border = {
                    # It is not a good idea to enable the focus-ring and the border
                    off = no-children;
                    width = 4;
                    active-color = "#ffc87f";
                    inactive-color = "#505050";
                    urgent-color = "#9b0000";
                };     
                shadow = {
                    softness = 30;
                    spread = 5;
                    offset = { _props = {x=0; y=5;}; };
                    color = "#0007";
                };
                struts = {
                    # left 64
                    # right 64
                    # top 64
                    # bottom 64
                };
            };

            spawn-at-startup = "waybar";
            #hotkey-overlay = {
            #    # Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
            #    # skip-at-startup
            #};

            screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
            #animation = {};
        });
    };
}