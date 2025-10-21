{ host, config, pkgs, lib, ...}:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {

        programs.hyprlock = {
            enable = true;
            settings = {
                general = {
                    disable_loading_bar = true;
                    grace = 10;
                    hide_cursor = true;
                    no_fade_in = false;
                };
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
