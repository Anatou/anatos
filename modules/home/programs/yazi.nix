{ lib, config, pkgs, ...}:

{
    options.my.home.programs.yazi.enable = lib.mkEnableOption "Enable my yazi configuration";

    config = lib.mkIf config.my.home.programs.yazi.enable {
        programs.yazi = {
            enable = true;
            enableBashIntegration = true;
            enableFishIntegration = true;
            enableZshIntegration = true;
        };
    };
}