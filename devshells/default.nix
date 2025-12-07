{ pkgs, lib, option, config, ... }:
let
    system = "x86_64-linux";
    self = "";
    devshells-flake = (import ./flake.nix).outputs { inherit self pkgs system; };
    devshells = devshells-flake.devshells;
in 
{
    options.my.home.scripts.devshell.enable = lib.mkEnableOption "Enable the devshell script";

    config = lib.mkMerge [
        (lib.mkIf config.my.home.scripts.devshell.enable {
            home.packages = [ devshells ];
        })
    ];
}