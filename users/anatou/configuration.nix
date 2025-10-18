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
        ]; 
        password = "anatou"; # default that must be changed (but at least user isn't locked out on first boot)
        shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    my.system.services.flatpak.enable = true;
}