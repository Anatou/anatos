{ host, config, pkgs, lib, username, ...}:

{
    # !!!!!!!!!!!!!!
    # hyprpaper has some troubles starting on its own
    # You must execute the following line after startup of your DE
    # `systemctl --user restart hyprpaper.service`

    options.my.home.programs.hyprlock.enable = lib.mkEnableOption "Enable my hyprlock configuration";
    options.my.home.programs.hyprlock.theme = lib.mkOption {
        type = lib.types.enum [ "mountain_sunset" "no_signal" ];
        default = "mountain_sunset";
        description = "Choose your hyprlock theme (mountain_sunset, no_signal)";
    };

    config = lib.mkIf config.my.home.programs.hyprlock.enable {

        programs.hyprlock = {
            enable = true;
            settings = lib.mkMerge [
                (lib.mkIf (config.my.home.programs.hyprlock.theme == "mountain_sunset") {
                    general = {
                        disable_loading_bar = true;
                        grace = 0; # tempo avant de demander un mdp
                        hide_cursor = true;
                        no_fade_in = false;
                    };
                    background = [
                        {
                            path = "/home/${username}/anatos/modules/home/programs/hyprlock/mountain_sunset.jpg";
                            blur_passes = 1;
                            blur_size = 3;
                            brightness = 0.8;       # fonce légèrement le fond pour plus de contraste
                            vibrancy = 0.15;        # ajoute une petite saturation au flou
                            vibrancy_darkness = 0.5;
                        }
                    ];
                    input-field = [
                        {
                            size = "200, 50";
                            position = "0, -80";
                            monitor = "";
                            dots_center = true;
                            fade_on_empty = false;
                            font_color = "rgb(CFE6F4)";
                            inner_color = "rgb(657DC2)";
                            outer_color = "rgb(0D0E15)";
                            outline_thickness = 5;
                            placeholder_text = "Password...";
                            shadow_passes = 2;
                        }
                    ];
                })

                (lib.mkIf (config.my.home.programs.hyprlock.theme == "no_signal") {
                    general = {
                        disable_loading_bar = true;
                        grace = 0; # tempo avant de demander un mdp
                        hide_cursor = true;
                        no_fade_in = true;
                        no_fade_out = true;
                    };
                    background = [
                        {
                            path = "/home/${username}/anatos/modules/home/programs/hyprlock/no_signal.png";
                        }
                    ];
                    input-field = [
                        {
                            size = "200, 50";
                            position = "-100, 100";
                            halign = "right";
                            valign = "bottom";
                            monitor = "";
                            dots_center = false;
                            fade_on_empty = true;
                            font_color = "rgb(FFFFFF)";
                            inner_color = "rgb(0000FF)";
                            outer_color = "rgb(0000FF)";
                            font_family = "Unifont";
                        }
                    ];
                })
            ];
        };
    };
}
