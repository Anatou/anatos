{ lib, config, ...}:

{
    options.my.home.programs.git.enable = lib.mkEnableOption "Enable my git configuration";

    config = lib.mkIf config.my.home.programs.git.enable {
        programs.git = {
            enable = true;
            userName = "Anatou";
            userEmail = "anatole@desnot.com";
            aliases = {
                a = "add .";
                p = "push";
                c = "commit";
                s = "status";
                br = "branch -a";
                sw = "switch";
            };
        };
    };
}