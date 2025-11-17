{ pkgs, ... }:
{
    home.packages = [
        (import ./waybar-on-special-ws.nix { inherit pkgs; })
    ];
}