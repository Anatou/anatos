{ lib, config, ...}:
{
    options.my.zsh.enable = lib.mkEnableOption "Enable my zsh configuration";

    config = lib.mkIf config.my.zsh.enable {
        programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            initContent = "echo 'Welcome to zsh !'";
            shellAliases = {
                c = "clear";
                gs = "git status";
                gadd = "git add .";
                gco = "git commit -m ";
                hm = "home-manager";
                hm-switch = "home-manager switch --flake ~/anatos";
                sys-switch = "sudo nixos-rebuild switch --flake ~/anatos";
                sys-boot = "sudo nixos-rebuild boot --flake ~/anatos";
            };
        };
    };
}