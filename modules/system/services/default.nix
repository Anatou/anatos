{ ... }: 

{
  imports = [
    ./audio.nix
    ./ssh.nix
    ./wireless.nix
    ./display-manager.nix
    ./flatpak.nix
    ./fonts.nix
    ./auto-mount-data-drive.nix
  ];
}