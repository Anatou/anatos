{ lib, config, pkgs, ...}:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {
        home.packages = with pkgs; [
            rofimoji
        ];

        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            extraConfig = {
                modi = "drun,filebrowser,run";
                show-icons = true;
                icon-theme = "Papirus";
                font = "JetBrainsMono Nerd Font Mono 12";
                drun-display-format = "{icon} {name}";
                display-drun = "Apps";
                display-run = "Run";
                display-filebrowser = "File";
            };
        };
    };
}