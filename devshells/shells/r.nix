{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "r";
in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "r";
        packages = with pkgs; [
            R
        ];
    };
}