{ lib, config, pkgs, ...}:

{
    options.my.system.services.wireless.enable = lib.mkEnableOption "Enable and configure wireless services";

    config = lib.mkIf config.my.system.services.wireless.enable {
        services.blueman.enable = true;
        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = false;

        networking.networkmanager.enable = true;
        environment.systemPackages = with pkgs; [
            networkmanagerapplet
        ];
    };
}