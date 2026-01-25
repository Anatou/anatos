{ lib, config, ...}:

{
    options.my.home.programs.git.enable = lib.mkEnableOption "Enable my git configuration";

    config = lib.mkIf config.my.home.programs.git.enable {
        programs.git = {
            enable = true;
            settings = {
                alias = {
                    a = "add .";
                    p = "push";
                    c = "commit";
                    s = "status";
                    l = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)%ad (%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --date=format:%Y-%m-%d@%H:%M:%S";
                    br = "branch -a";
                    sw = "switch";
                };

                user = {
                    name = "Anatou";
                    email = "anatole@desnot.com";
                };
            };
        };
        home.shellAliases = {
            commit = "git commit -m ";
            push = "git push";
            pull = "git pull";
            clone = "git clone";
            switch = "git switch";
            switchc = "git switch -c";
            branch = "git branch";
            brancha = "git branch -a";
            fetch = "git fetch";
            fetchp = "git fetch --prune";

            gs = "git status";
            gadd = "git add .";
            glog = "git l";
            glg = "git l";
            gsw = "git switch";
            gswc = "git switch -c";
            gbra = "git branch -a";
            gbr = "git branch";
            gfetch = "git fetch --prune";
            
        };
    };
}