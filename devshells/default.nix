{ nixpkgs, pkgs, lib, option, config, ... }:
let
    self = "";
    devshells-flake = (import ./flake.nix).outputs { inherit self nixpkgs; };
    devshell = devshells-flake.devshell;
in 
{
    options.my.devShells.enable = lib.mkEnableOption "Enable the devshell script";

    config = lib.mkMerge [
        (lib.mkIf config.my.devShells.enable {
            home.packages = [ devshell ];
        })
    ];
}