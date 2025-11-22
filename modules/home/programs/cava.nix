{ lib, config, ...}:

{
    options.my.home.programs.cava.enable = lib.mkEnableOption "Enable my cava configuration";

    config = lib.mkIf config.my.home.programs.cava.enable {
        programs.cava = {
            enable = true;
        };
    };
}