{ pkgs, ...}:
{ name, packages ? [], env ? {}, shellHook ? "", function, prefix }: pkgs.mkShell {
    name = "${name}";
    packages = packages;
    env = {
        SH = "bash";
        DEVSHELL = name;
    } // env;
    shellHook = shellHook;
}