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
        ./tailscale.nix
        ./udiskie.nix
        ./meteofrance-daemon.nix
    ];
}