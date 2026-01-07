{ pkgs ? import <nixpkgs> {} }:
let
    system = "x86_64-linux";
    self = "";
    mkFHSDevShell = (import ../lib/fhs-devshell.nix) { inherit pkgs; };
in 

(mkFHSDevShell {
    name = "FHS";
    packages = with pkgs; [
        cmake
        ninja
        vcpkg 
        patchelf
    ];
}).env