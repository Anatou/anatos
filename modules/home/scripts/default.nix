{ pkgs, lib, option, config, system, ... }:
{
    options.my.home.scripts.devshell.enable = lib.mkEnableOption "Enable the devshell script";
    options.my.home.scripts.waybar-on-special-ws.enable = lib.mkEnableOption "Enable the waybar-on-special-ws script";
    options.my.home.scripts.niri-media-switcher.enable = lib.mkEnableOption "Enable the niri-media-switcher script";

    config = lib.mkMerge [
        (lib.mkIf config.my.home.scripts.devshell.enable {
            home.packages = [
                pkgs.jq
                (import ./devshell.nix { inherit pkgs system; })
            ];
        })
        (lib.mkIf config.my.home.scripts.waybar-on-special-ws.enable {
            home.packages = [(import ./waybar-on-special-ws.nix { inherit pkgs; })];
        })
        (lib.mkIf config.my.home.scripts.niri-media-switcher.enable {
            home.packages = [(import ./niri-media-switcher.nix { inherit pkgs; })];
        })
    ];
}