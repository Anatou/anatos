{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "java";
in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "java";
        packages = with pkgs; [
            temurin-bin
        ];
    };
}