{ inputs, config, pkgs, system, host, username, zen-browser-flake, ... }:

{
    imports = [
        ./../../modules/home
    ];
    nixpkgs.config.allowUnfree = true;

    # ============= User configuration ============= #
    home.username = "anatou";
    home.homeDirectory = "/home/anatou";
    # D'autres options de home pour config les différents affichages, langues, variables, curseurs, etc...

    # ============= User desktop environment ============= #
    # Don't forget to activate the DE from the system configuration as well
    # This is merely the DE configuration, home-manager does not have enough
    # authority to completely manage the DEs
    my.home.programs.hyprland.enable = true;

    # ============= User programs ============= #
    home.packages = with pkgs; [
        hello
        htop
        vscode
        fastfetch
    ];
    programs.fastfetch.enable = true;

    # Programs with personnal settings
    my.home.programs.git.enable = true;
    my.home.programs.zsh.enable = true;

    # ============= User shell ============= #
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