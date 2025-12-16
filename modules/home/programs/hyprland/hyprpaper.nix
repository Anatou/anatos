{ host, config, pkgs, lib, username, ...}:

{
config = lib.mkIf (config.my.home.programs.hyprland.enable || config.my.home.programs.niri.enable) {

    services.hyprpaper = {
        enable = true;
        settings = {
            preload = [ "/home/${username}/anatos/modules/home/programs/hyprland/modane-montagne.jpg" ];
            wallpaper = [ ",/home/${username}/anatos/modules/home/programs/hyprland/modane-montagne.jpg" ];
        };
    };
};
}