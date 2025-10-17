{ lib, config, ...}:

{
    options.my.system.services.wireless.enable = lib.mkEnableOption "Enable and configure wireless services";

    config = lib.mkIf config.my.system.services.wireless.enable {
        services.blueman.enable = true;
        networking.networkmanager.enable = true;
    };
}