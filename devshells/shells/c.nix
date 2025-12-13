{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "c";
in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "c";
        packages = with pkgs; [
            libgcc
            cmake
            clang-tools
            gdb
            valgrind-light
        ];
    };
}