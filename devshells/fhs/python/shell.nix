{ pkgs ? import <nixpkgs> {} }:
let
    system = "x86_64-linux";
    self = "";
    mk-FHS-devshells = (import ../../lib/FHS-devshell.nix).outputs { inherit self pkgs system; };
    mkFHSDevShell = mk-FHS-devshells.mkFHSDevShell;
in 

(mkFHSDevShell {
    name = "python3.13-fhs";
    packages = with pkgs; [ python313 python313Packages.pip ];
}).env