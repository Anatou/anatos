{ inputs, config, pkgs, system, host, username, ... }:

{
      # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.anatou = {
        isNormalUser = true;
        extraGroups = [ 
            "wheel" # Enable ‘sudo’ for the user.
            "adbusers"
        ]; 
        shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
}