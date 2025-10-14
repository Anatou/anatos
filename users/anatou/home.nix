{ inputs, config, pkgs, system, host, username, zen-browser-flake, ... }:

{
    imports = [
        ./../../modules/home/programs
    ];
    
    nixpkgs.config.allowUnfree = true;

    home.username = "anatou";
    home.homeDirectory = "/home/anatou";
    # D'autres options de home pour config les différents affichages, langues, variables, curseurs, etc...

    # Les packages à utiliser dans l'environnement utilisateur
    home.packages = [
        pkgs.hello
        pkgs.htop
        pkgs.vscode
        pkgs.fastfetch
    ];

    programs.fastfetch.enable = true;

    my.git.enable = true;
    my.zsh.enable = true;
    my.hyprland.enable = true;

    home.sessionVariables = {
        EDITOR = "vim";
        FOO = "Hello";
    };

    home.shellAliases = {
        hi = "echo Hi !";
    };

    # creuser nix-colors

    xdg.mimeApps.defaultApplications = {
        "text/plain" = [ "app.desktop" ];
    };

    programs.home-manager.enable = true;
    home.stateVersion = "25.05";
}