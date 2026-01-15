{ inputs, config, nixpkgs, pkgs, system, host, username, ... }:

{
    imports = [
        ./../../modules/home
    ];
    nixpkgs.config.allowUnfree = true;

    # ============= User configuration ============= #
    home.username = "${username}";
    home.homeDirectory = "/home/${username}";
    # D'autres options de home pour config les différents affichages, langues, variables, curseurs, etc...

    # ============= User desktop environment ============= #
    # Don't forget to activate the DE from the system configuration as well
    # This is merely the DE configuration, home-manager does not have enough
    # authority to completely manage the DEs
    my.home.programs.hyprland.enable = true;
    my.home.programs.hyprlock.theme = "no_signal";
    my.home.programs.hyprpaper.theme = "mountain_sunset";
    my.home.programs.niri.enable = true;
    
    # ============= User programs ============= #
    home.packages = with pkgs; [
        # Base
        spotify
        # File opening/manipulation
        libreoffice-still
        gedit
        vlc
        qimgv
        ungoogled-chromium
        zathura
        # Art/creation
        cowsay
        mermaid-cli
        zip
        inotify-tools
    ];

    # Programs with personnal settings
    my.home.programs.git.enable = true;
    my.home.programs.zsh.enable = true;
    my.home.programs.zoxide.enable = true;
    my.home.programs.fastfetch.enable = true;
    my.home.programs.btop.enable = true;
    my.home.programs.kitty.enable = true;
    my.home.programs.starship.enable = true;
    my.home.programs.neovim.enable = true;
    my.home.programs.vscode.enable = true;
    my.home.programs.thunar.enable = true;
    my.home.programs.yazi.enable = true;
    my.home.programs.zathura.enable = true;

    # Flatpak programs
    my.home.services.flatpak.packages = [
        "io.github.zen_browser.zen"
    ];
    services.flatpak.overrides = {
        "app.zen_browser.zen".Context = {
            filesystems = [
                "xdg-download"
                "/run/.heim_org.h5l.kcm-socket"
                "xdg-run/speech-dispatcher:ro"
                "/home/${username}" # give zen full access to home directory
            ];
        };
    };

    # ============= User services ============= #
    my.home.services.meteofrance-daemon.enable = true;
    my.home.services.udiskie.enable = true;
    my.home.services.stylix.enable = true;
    my.home.services.cursor = "bibata";
    my.home.services.wayland-screenshot.enable = true;
    my.home.services.default-apps = {
        enable = true;
        url = [ "app.zen_browser.zen.desktop" ];
        pdf = [ "org.pwmt.zathura.desktop" ];
        text = [ "org.gnome.gedit.desktop" ];
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

    # ============= User scripts ============= #
    my.home.scripts.devshell.enable = true;
    
    # ============= User fonts ============= #
    my.home.services.fonts.extra = with pkgs; [
        fira-code
        fira-code-symbols
        jetbrains-mono
        minecraftia
        noto-fonts-color-emoji
    ];

    # ============= User shell ============= #
    home.sessionVariables = {
        FOO = "Hello";
        SYSTEM = "${system}";
        EDITOR = "nvim";
    };
    home.shellAliases = {
        hi = "echo Hi !";
        py = "devshell python:shell";
        hgrep = "history | grep ";
        c = "clear";
        f = "clear && fastfetch";
        gs = "git status";
        gadd = "git add .";
        glg = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)%ad (%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --date=format:%Y-%m-%d@%H:%M:%S";
        commit = "git commit -m ";
        push = "git push";
        pull = "git pull";
        gsw = "git switch";
        gswc = "git switch -c";
        gbr = "git branch -a";
        gbra = "git branch";
        gfetch = "git fetch --prune";
        #hm = "home-manager";
        #hm-switch = "home-manager switch --flake ~/anatos && source ~/.zshrc";
        sys-switch = "sudo nixos-rebuild switch --flake ~/anatos && source ~/.zshrc";
        sys-boot = "sudo nixos-rebuild boot --flake ~/anatos";
        list-sys-gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        list-user-gens = "nix-env --list-generations";
        gc-sys-all = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old";
        gc-sys-pick = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
        gc-user-all = "nix-env --delete-generations old";
        gc-user-pick = "nix-env --delete-generations";
        gc-store = "nix-store --gc";
        gc-purge = "gc-sys-all && gc-user-all && gc-store";
        ls-desktop-files = ''
            LSOUTPUT="";
            LSOUTPUT=$LSOUTPUT"================ .desktop from flatpak ================\n";
            LSOUTPUT=$LSOUTPUT$(ls -1 /var/lib/flatpak/**/current/active/export/share/applications/ | grep -v -e '^[[:space:]]*$' -e '/var');
            LSOUTPUT=$LSOUTPUT"\n================ .desktop from home-manager ================\n";
            LSOUTPUT=$LSOUTPUT$(ls -1 ~/.nix-profile/share/applications);
            LSOUTPUT=$LSOUTPUT"\n================ .desktop from nixos system ================\n";
            LSOUTPUT=$LSOUTPUT$(ls -1 /run/current-system/sw/share/applications);
            echo $LSOUTPUT'';
        mermaid = "mmdc";
    };

    # creuser nix-colors

    programs.home-manager.enable = true;
    home.stateVersion = "25.05";
}