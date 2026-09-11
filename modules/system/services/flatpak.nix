{ lib, config, pkgs, ...}:
let

in
{
    options.my.system.services.flatpak = {
        enable = lib.mkEnableOption "Enable flatpak system services";
    }; 

    config = lib.mkIf config.my.system.services.flatpak.enable {
        services.flatpak.enable = true;
    };
}