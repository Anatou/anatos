{ lib, config, pkgs, ...}:

{
    options.my.home.programs.thunar.enable = lib.mkEnableOption "Enable my thunar configuration";

    config = lib.mkIf config.my.home.programs.thunar.enable {
        home.packages = with pkgs; [
            xfce.thunar
            xfce.thunar-volman
            xfce.thunar-dropbox-plugin
            xfce.thunar-vcs-plugin
            xfce.thunar-archive-plugin
            xfce.thunar-media-tags-plugin
        ];
    };
}