{ inputs, config, pkgs, system, host, username, ... }:

{
    imports = [
        ./../../modules/home/programs
    ];

    home.username = "anatou";
    home.homeDirectory = "/home/anatou";
    # D'autres options de home pour config les différents affichages, langues, variables, curseurs, etc...

    # Les packages à utiliser dans l'environnement utilisateur
    home.packages = [
        pkgs.hello
        pkgs.htop
    ];

    my.git.enable = true;
    my.zsh.enable = true;

    home.sessionVariables = {
        EDITOR = "vim";
        FOO = "Hello";
    };

    home.shellAliases = {
        hi = "echo Hi !";
    };

    home.shell.enableShellIntegration = true;

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
        };
    };

    # creuser nix-colors

    xdg.mimeApps.defaultApplications = {
        "text/plain" = [ "app.desktop" ];
    };

    programs.home-manager.enable = true;
    home.stateVersion = "25.05";
}