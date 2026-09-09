{ inputs, config, pkgs, system, host, username, lib, ... }:

{
    imports = [
        ./../../modules/system
    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.anatou = {
        isNormalUser = true;
        extraGroups = [ 
            "wheel" # Enable ‘sudo’ for the user.
            "adbusers"
            "networkmanager"
            "docker"
            "libvirtd"
            "vboxusers"
            "render"
            "video"
            "input"
        ]; 
        password = "anatou"; # default that must be changed (but at least user isn't locked out on first boot)
        shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    programs.uwsm = {
        enable = true;
        waylandCompositors = {
            hyprland = {
                prettyName = "Hyprland";
                comment = "Hyprland compositor managed by UWSM";
                binPath = "/run/current-system/sw/bin/start-hyprland";

            };
        };
    };
    programs.niri.enable = true;
    programs.nix-ld.enable = true;
    #security.pam.services.hyprlock = {
    #    text = ''auth include login'';
    #};

    security.sudo.extraConfig = ''
        Defaults env_keep += "DISPLAY XAUTHORITY"
    '';
    environment.systemPackages = [ pkgs.xhost ];
    systemd.user.services.allow-root-x11 = {
        description = "Autorize root (via sudo) to connect to the XWayland display ";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.xhost}/bin/xhost +SI:localuser:root";
        };
    };

    # Gaming services
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;
    hardware.xpadneo.enable = true;
    
    # Thunar services
    programs.xfconf.enable = true;
    services.gvfs.enable = true; 
    services.tumbler.enable = true;

    # udiskie services
    services.udisks2.enable = true;
    services.atd.enable = true;

    my.system.services.flatpak.enable = true;
    my.system.services.auto-mount-data-drive.enable = true;
}