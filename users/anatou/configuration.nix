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
        ]; 
        password = "anatou"; # default that must be changed (but at least user isn't locked out on first boot)
        shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    programs.hyprland.enable = true;
    #security.pam.services.hyprlock = {
    #    text = ''auth include login'';
    #};
    
    my.system.services.flatpak.enable = true;
}