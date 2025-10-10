{ lib, ...}:
{
    options.programs.git.enable = lib.mkEnableOption "Enable Git";

    config = lib.mkIf config.programs.git.enable {
        programs.git = {
            enable = true;
            #userName = "Anatou";
            #userEmail = "anatole@desnot.com";
            aliases = {
                a = "add .";
                p = "push";
                c = "commit -m";
                s = "status";
                br = "branch -a";
                sw = "switch";
            }
        };
    }
}