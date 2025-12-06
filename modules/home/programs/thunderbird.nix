{ lib, config, pkgs, ...}:

{
    options.my.home.programs.thunderbird.enable = lib.mkEnableOption "Enable my thunderbird configuration";

    config = lib.mkIf config.my.home.programs.thunderbird.enable {
        accounts.email.accounts."personnel" = {
            address = "anatole@desnot.com";
            realName = "Anatole Desnot";
            primary = true;
            #imap = {
            #    host = "outlook.office365.com";
            #    port = 993;
            #};
            #passwordCommand = "cat ${config.age.secrets.microsoft.path}";
            thunderbird = {
                enable = true;
                profiles = [ "personnel" ];
            };

        };
        programs.thunderbird = {
            enable = true;
            settings = {
                "general.useragent.override" = "";
                "privacy.donottrackheader.enabled" = true;
            };  
            profiles = {
                "personnel".isDefault = true;
            };               
        };
    };
}