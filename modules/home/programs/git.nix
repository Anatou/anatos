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
                l = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)%ad (%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --date=format:%Y-%m-%d@%H:%M:%S";
                br = "branch -a";
                sw = "switch";
            };
        };
    };
}