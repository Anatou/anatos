{ pkgs, lib, config, nixosConfig, ... }:
{

    options.my.home.services.podman.enable = lib.mkEnableOption "Enable podman";

    config = lib.mkIf config.my.home.services.podman.enable {
        services.podman = {
            enable = true;
        };
    };
}



