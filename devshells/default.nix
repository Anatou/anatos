{ nixpkgs, pkgs, lib, option, config, ... }:
let
    self = "";
    devshells-flake = (import ./devshell.nix).outputs { inherit self nixpkgs; };
    devshell = devshells-flake.devshell;
in 
{
    options.my.devshells.enable = lib.mkEnableOption "Enable the devshell functionality";

    config = lib.mkMerge [
        (lib.mkIf config.my.devshells.enable {
            home.packages = [ devshell ];
        })
    ];
}