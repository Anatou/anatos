{ lib, config, pkgs, ...}:

{
    options.my.system.services.fonts = {
        default.enable = lib.mkEnableOption "Enable default fonts";
        extra = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [];
        };
    }; 

    defaultFonts = if config.my.system.services.fonts.default.enable then [
        font-awesome
        material-icons
        nerd-fonts.symbols-only
        nerd-fonts.hack
    ] else [];

    fonts = {
        packages = with pkgs; 
        defaultFonts
        ++ config.my.system.services.fonts.extra;
    };
}