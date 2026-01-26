{ lib, config, pkgs, ...}:

{
    options.my.system.services.printing.enable = lib.mkEnableOption "Enable my printing configuration";

    config = lib.mkIf config.my.system.services.printing.enable {
        services.printing = {
            enable = true;
            drivers = [ pkgs.gutenprint pkgs.hplip pkgs.epson-escpr2 pkgs.epson-escpr2 pkgs.postscript-lexmark pkgs.samsung-unified-linux-driver pkgs.splix pkgs.brlaser pkgs.brgenml1lpr pkgs.cnijfilter2 pkgs.brgenml1cupswrapper ];

        };
        services.avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
        };
    };
}

