{ lib, config, pkgs, ...}:

{
    options.my.home.programs.thunderbird.enable = lib.mkEnableOption "Enable my thunderbird configuration";

    config = lib.mkIf config.my.home.programs.thunderbird.enable {

        programs.thunderbird = {
            enable = true;
            settings = {
                "general.useragent.override" = "";
                "privacy.donottrackheader.enabled" = true;
            };  
            profiles = {
                "Anatole" = {
                    name = "Anatole Desnot";
                };
            };               
        };
    };
}