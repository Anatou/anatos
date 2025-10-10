{ inputs, config, pkgs, system, host, username, ... }:

{
    modules = [
        ./../../modules/home/programs
    ];

    home.username = "${username}";
    home.homeDirectory = "/home/${username}";
    # D'autres options de home pour config les différents affichages, langues, variables, curseurs, etc...

    # Les packages à utiliser dans l'environnement utilisateur
    home.packages = [
        pkgs.hello
    ];

    home.programs = {
        git.enable = true;
        zsh.enable = true;
    };

    home.sessionVariables = {
        EDITOR = "vim";
    };

    # creuser nix-colors

    xdg.mimeApps.defaultApplications = {
        "text/plain" = [ "app.desktop" ];
    };

    programs.home-manager.enable = true;
}
