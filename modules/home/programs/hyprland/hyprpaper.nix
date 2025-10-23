{ host, config, pkgs, lib, username, ...}:

{
config = lib.mkIf config.my.home.programs.hyprland.enable {

    services.hyprpaper = {
        enable = true;
        settings = {
            preload = [ "/home/${username}/anatos/modules/home/programs/hyprland/hyprpaper.jpg" ];
            wallpaper = [ "Virtual-1,/home/${username}/anatos/modules/home/programs/hyprland/hyprpaper.jpg" ];
        };
    };
};
}