{ lib, config, ...}:

{
    options.my.pipewire.enable = lib.mkEnableOption "Enable my pipewire configuration";

    config = lib.mkIf config.my.pipewire.enable {
        services.pipewire = {
            enable = true;
            pulse.enable = true;
        };
    };
}