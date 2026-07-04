{ ... }: 

{
  imports = [
    ./at.nix
    ./audio.nix
    ./ssh.nix
    ./wireless.nix
    ./howdy.nix
    ./display-manager.nix
    ./flatpak.nix
    ./printing.nix
    ./fonts.nix
    ./auto-mount-data-drive.nix
    ./splashscreen.nix
  ];
}