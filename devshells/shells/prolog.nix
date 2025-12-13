{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "prolog";
in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "swi-prolog";
        packages = with pkgs; [
            swi-prolog
        ];
    };
}