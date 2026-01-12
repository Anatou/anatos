{ pkgs, ...}:
let
    make-devshell-name = (import ./make-devshell-name.nix);
in
{ name, packages ? [], env ? {}, shellHook ? "", function, prefix }: pkgs.mkShell {
    name = "${name}";
    packages = packages;
    env = {
        SH = "bash";
    } // env;
    shellHook = make-devshell-name name + shellHook;
}