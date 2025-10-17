{ lib, config, ...}:

{
    options.my.system.services.openssh.enable = lib.mkEnableOption "Enable and configure ssh services";

    config = lib.mkIf config.my.system.services.openssh.enable {
        services.openssh = {
            enable = true;
            settings = {
                # Some sweet security measures
                PermitRootLogin = "no";
                PasswordAuthentication = true;
                KbdInteractiveAuthentication = true;
            };
            ports = [ 22 ];

        };
    };
}