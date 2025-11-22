{ lib, config, pkgs, ...}:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {
        home.packages = with pkgs; [
            mako
        ];
        home.file.".config/mako/config".text = ''
            ignore-timeout=1
            default-timeout=5000
            max-visible=10
            width=280
            font=FiraCode

            background-color=#000000FF

            border-size=0
            border-radius=10

            [mode=hide]
            invisible=1
        '';
    };
}