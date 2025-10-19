{ lib, config, pkgs, ...}:

{
    options.my.home.programs.rofi.enable = lib.mkEnableOption "Enable my rofi configuration";

    config = lib.mkIf config.my.home.programs.rofi.enable {
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