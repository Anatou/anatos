{ host, config, pkgs, lib, username, ...}:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {

        programs.hyprlock = {
            enable = true;
            settings = {
                general = {
                    disable_loading_bar = true;
                    grace = 0; # tempo avant de demander un mdp
                    hide_cursor = true;
                    no_fade_in = false;
                };
                background = [
                    {
                        path = "/home/${username}/anatos/modules/home/programs/hyprland/hyprlock.jpg";
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
            };
        };
    };
}
