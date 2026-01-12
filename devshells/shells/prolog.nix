{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "prolog";
in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "swiprolog";
        packages = with pkgs; [
            swi-prolog
        ];
    };
}