{ lib, config, pkgs, ...}:
let 
    defaultFonts = if config.my.system.services.fonts.default.enable then [
        pkgs.font-awesome
        pkgs.material-icons
        pkgs.nerd-fonts.symbols-only
        pkgs.nerd-fonts.hack
    ] else [];
in
{
    options.my.system.services.fonts = {
        default.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
        };
        extra = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [];
        };
    }; 

    config = {
        fonts.packages =
            defaultFonts
            ++ config.my.system.services.fonts.extra;
    };
}