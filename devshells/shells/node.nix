{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "node";
in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "nodejs";
        packages = with pkgs; [
            nodejs_24
        ];
    };
}