{ lib, config, pkgs, ...}:

{
    options.my.system.services.splashscreen.enable = lib.mkEnableOption "Enable and configure boot splashscreen";

    config = lib.mkIf config.my.system.services.splashscreen.enable {
        # theme names @https://github.com/NixOS/nixpkgs/blob/nixos-25.05/pkgs/by-name/ad/adi1090x-plymouth-themes/shas.nix
        # theme list @https://github.com/adi1090x/plymouth-themes?tab=readme-ov-file

        boot.plymouth = {
            enable = true;
            theme = "colorful_sliced";
            themePackages = with pkgs; [
                adi1090x-plymouth-themes
            ];
        };
    };
}