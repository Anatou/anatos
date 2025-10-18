{ lib, config, ...}:
{
    options.my.home.programs.zsh.enable = lib.mkEnableOption "Enable my zsh configuration";

    config = lib.mkIf config.my.home.programs.zsh.enable {
        programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            initContent = "echo 'Welcome to zsh !'";
            shellAliases = {
                c = "clear";
                f = "clear && fastfetch";
                gs = "git status";
                gadd = "git add .";
                gpsh = "git push";
                gpll = "git pull";
                gco = "git commit -m ";
                hm = "home-manager";
                hm-switch = "home-manager switch --flake ~/anatos";
                sys-switch = "sudo nixos-rebuild switch --flake ~/anatos";
                sys-boot = "sudo nixos-rebuild boot --flake ~/anatos";
            };
        };
    };
}