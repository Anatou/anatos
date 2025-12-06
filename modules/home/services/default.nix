{ ... }:
{
    imports = [
        ./wayland-screenshot.nix
        ./fonts.nix
        ./flatpak.nix
        ./cursor.nix
        ./default-apps.nix
        ./user-dirs.nix
        ./stylix.nix
        ./udiskie.nix
        ./meteofrance-daemon.nix
    ];
}