{ ... }: 

{
  imports = [
    ./audio.nix
    ./ssh.nix
    ./wireless.nix
    ./display-manager.nix
    ./flatpak.nix
    ./fonts.nix
  ];
}