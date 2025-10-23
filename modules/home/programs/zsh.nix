{ lib, config, ...}:
{
    options.my.home.programs.zsh.enable = lib.mkEnableOption "Enable my zsh configuration";

    config = lib.mkIf config.my.home.programs.zsh.enable {
        programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            initContent = ''if [ -z "$DEVSHELL" ]; then fastfetch && echo "\nCoucou bebou ^-^ Je t'aime ! "; fi'';
            shellAliases = {
                c = "clear";
                f = "clear && fastfetch";
                gs = "git status";
                gadd = "git add .";
                gps = "git push";
                gpl = "git pull";
                gco = "git commit -m ";
                hm = "home-manager";
                hm-switch = "home-manager switch --flake ~/anatos";
                sys-switch = "sudo nixos-rebuild switch --flake ~/anatos";
                sys-boot = "sudo nixos-rebuild boot --flake ~/anatos";
            };
        };
    };
}