{ inputs, config, pkgs, system, host, username, ... }:

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
        ]; 
        password = "anatou"; # default that must be changed (but at least user isn't locked out on first boot)
        shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    programs.hyprland.enable = true;
    #security.pam.services.hyprlock = {
    #    text = ''auth include login'';
    #};


    programs.steam.enable = true;

    # Thunar services
    programs.xfconf.enable = true;
    services.gvfs.enable = true; 
    services.tumbler.enable = true;

    # udiskie services
    services.udisks2.enable = true;

    
    my.system.services.flatpak.enable = true;
    my.system.services.auto-mount-data-drive.enable = true;
}