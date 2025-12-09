{ pkgs ? import <nixpkgs> {} }:
let
    system = "x86_64-linux";
    self = "";
    mk-FHS-devshells = (import ../lib/FHS-devshell.nix).outputs { inherit self pkgs system; };
    mkFHSDevShell = mk-FHS-devshells.mkFHSDevShell;
in 

(mkFHSDevShell {
    name = "FHS";
    packages = with pkgs; [
        cmake
        ninja
        vcpkg 
    ];
}).env