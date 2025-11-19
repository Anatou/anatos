{ lib, config, pkgs, osConfig, ...}:

{
    options.my.home.services.flatpak = {
        packages = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
        };
    }; 

    config = lib.mkIf osConfig.my.system.services.flatpak.enable {
        services.flatpak = {
            packages = [
                # Those two packages manage flatpak
                "com.github.tchx84.Flatseal" 
                "io.github.flattool.Warehouse"
            ] ++ config.my.home.services.flatpak.packages;
        update.onActivation = true;
        };
    };
}