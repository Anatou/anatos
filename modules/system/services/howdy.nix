{ lib, config, ...}:

{
    options.my.system.services.howdy.enable = lib.mkEnableOption "Enable and configure howdy authentication";

    config = lib.mkIf config.my.system.services.howdy.enable {
        services.howdy = {
            enable = true;
            control = "sufficient";
        };
        services.linux-enable-ir-emitter = {
            enable = true;
        };
        security.pam.services.hyprlock.howdy.enable = true;
        security.pam.services.sudo.howdy.enable = false;
        security.pam.services.ly.howdy.enable = false;
    };
}