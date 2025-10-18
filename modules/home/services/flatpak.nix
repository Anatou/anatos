{ lib, config, ...}:

{
    options.my.home.services.flatpak = {
        enable = lib.mkEnableOption "Enable and configure flatpak services";
        packages = lib.mkOption {
            type = types.list;
            default = [];
        };
    }; 

    config = lib.mkIf config.my.home.services.flatpak.enable {
        services.flatpak = {
            enable = true;
            packages = [
                # Those two packages manage flatpak
                "com.github.tchx84.Flatseal" 
                "io.github.flattool.Warehouse"
            ] ++ my.home.services.flatpak.packages;
            update.onActivation = true;
        };

        xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
            configPackages = [ pkgs.hyprland ];
        };
    };
}