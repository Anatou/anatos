{ lib, config, pkgs, ...}:

{
    options.my.home.services.fonts = {
        extra = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [];
        };
    }; 

    # Home-manager does not have a font specific option
    # Fonts are installed as regular packages
    # Fonts are loaded automatically if the option below is true
    fonts.fontconfig.enable = true;
    home.packages = {
        packages = with pkgs; config.my.home.services.fonts.extra;
    };
}