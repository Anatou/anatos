{ inputs, config, pkgs, system, host, username, ... }:

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
    my.home.programs.hyprland.hyprpaperTheme = "no_signal";
    my.home.programs.rofi.enable = true;

    # ============= User programs ============= #
    home.packages = with pkgs; [
        obsidian
        spotify
        inkscape-with-extensions
        libreoffice-still
        gedit
        vlc
        qimgv
        cowsay
        # gnome-calendar
    ];

    # Programs with personnal settings
    my.home.programs.git.enable = true;
    my.home.programs.zsh.enable = true;
    my.home.programs.zoxide.enable = true;
    my.home.programs.fastfetch.enable = true;
    my.home.programs.btop.enable = true;
    my.home.programs.kitty.enable = true;
    my.home.programs.starship.enable = true;
    my.home.programs.vscode.enable = true;
    my.home.programs.jetbrains-toolbox.enable = true;
    my.home.programs.thunar.enable = true;
    my.home.programs.yazi.enable = true;

    # Flatpak programs
    my.home.services.flatpak.packages = [
        "io.github.zen_browser.zen"
    ];
    services.flatpak.overrides = {
        "io.github.zen_browser.zen".Context = {
            filesystems = [
                "xdg-download"
                "/run/.heim_org.h5l.kcm-socket"
                "xdg-run/speech-dispatcher:ro"
                "home" # give zen full access to home directory
            ];
        };
    };

    # ============= User services ============= #
    my.home.services.cursor = "bibata";
    my.home.services.wayland-screenshot.enable = true;
    my.home.services.default-apps = {
        enable = true;
        url = [ "app.zen_browser.zen.desktop" ];
        pdf = [ "app.zen_browser.zen.desktop" ];
        text = [ "gedit.desktop" ];
        code = [ "code.desktop" ];
        video = [ "vlc.desktop" ];
        audio = [ "vlc.desktop" ];
        image = [ "qimgv.desktop" ];
    };

    my.home.services.user-dirs = {
        enable = true;
        documents = "documents";
        download = "download";
    };
    
    # ============= User fonts ============= #
    my.home.services.fonts.extra = with pkgs; [
        fira-code
        fira-code-symbols
        jetbrains-mono
        minecraftia
        noto-fonts-emoji
    ];

    # ============= User shell ============= #
    home.sessionVariables = {
        EDITOR = "vim";
        FOO = "Hello";
    };
    home.shellAliases = {
        hi = "echo Hi !";
        python = "devshell python-shell";
    };

    # creuser nix-colors


    programs.home-manager.enable = true;
    home.stateVersion = "25.05";
}