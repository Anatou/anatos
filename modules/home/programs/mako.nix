{ lib, config, pkgs, ...}:

{
    options.my.home.programs.mako.enable = lib.mkEnableOption "Enable my mako configuration";

    config = lib.mkIf config.my.home.programs.mako.enable {
        home.packages = with pkgs; [
            mako
            inotify-tools
        ];
        home.file.".config/mako/config".text = ''
            ignore-timeout=1
            default-timeout=5000
            max-visible=10
            width=330
            font=FiraCode

            background-color=#000000FF

            border-size=0
            border-radius=10

            [mode=hide]
            invisible=1
        '';
    };
}