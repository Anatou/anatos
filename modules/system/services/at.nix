{ lib, config, pkgs, ...}:

{
    options.my.system.services.at.enable = lib.mkEnableOption "Enable at";

    config = lib.mkIf config.my.system.services.at.enable {
        services.atd.enable = true;
        environment.systemPackages = with pkgs; [
            at
        ];
    };
}

