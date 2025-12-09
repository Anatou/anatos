{ lib, config, pkgs, ...}:

{
    options.my.home.programs.zathura.enable = lib.mkEnableOption "Enable my zathura configuration";

    config = lib.mkIf config.my.home.programs.zathura.enable {
        programs.zathura = {
            enable = true;
            mappings = {
                "<S-Left>" = "navigate previous";
                "<S-Up>" = "navigate previous";
                "<PageUp>" = "navigate previous";
                "<KPPageUp>" = "navigate previous";
                "<S-Right>" = "navigate next";
                "<S-Down>" = "navigate next";
                "<PageDown>" = "navigate next";
                "<KPPageDown>" = "navigate next";

                "<C-Left>" = "zoom out";
                "<C-Up>" = "zoom out";
                "<C-Right>" = "zoom in";
                "<C-Down>" = "zoom in";
            };
        };
    };
}