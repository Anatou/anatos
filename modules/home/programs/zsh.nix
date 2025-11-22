{ lib, config, ...}:
{
    options.my.home.programs.zsh.enable = lib.mkEnableOption "Enable my zsh configuration";

    config = lib.mkIf config.my.home.programs.zsh.enable {
        programs.zsh = {
            enable = true;
            autocd = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            initContent = ''
                if [ -z "$DEVSHELL" ]; then fastfetch && echo "\nCoucou bebou ^-^ Je t'aime ! "; fi
                bindkey "^H" backward-kill-word
                bindkey "^[^?" backward-kill-word
            '';
            localVariables = {
                PROMPT = "%(?..%F{9}× )%f%2~ %(!.#.>) ";
            };
            shellAliases = {
                hgrep = "history | grep ";
                c = "clear";
                f = "clear && fastfetch";
                gs = "git status";
                gadd = "git add .";
                gps = "git push";
                push = "git push";
                gpl = "git pull";
                pull = "git pull";
                gco = "git commit -m ";
                glg = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)%ad (%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --date=format:%Y-%m-%d@%H:%M:%S";
                #hm = "home-manager";
                #hm-switch = "home-manager switch --flake ~/anatos && source ~/.zshrc";
                sys-switch = "sudo nixos-rebuild switch --flake ~/anatos";
                sys-boot = "sudo nixos-rebuild boot --flake ~/anatos";
                list-sys-gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
                list-user-gens = "nix-env --list-generations";
                gc-sys-gens-all = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old";
                gc-sys-gens-pick = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
                gc-user-gens-all = "nix-env --delete-generations old";
                gc-user-gens-pick = "nix-env --delete-generations";
                gc-store = "nix-store --gc";
            };
        };
    };
}