{ ... }:
# let
# devshellPackages = builtins.attrValues (builtins.mapAttrs (
#     name: shell: shell#.inputDerivation
# ) devshells.devShells.${system});
# in
{
    imports = [
        ./lxc-help.nix
        ./devshell.nix
        ./waybar-on-special-ws.nix
    ];
}