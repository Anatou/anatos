{
    description = "A function creating a devshell with bash";

    outputs = { self, pkgs, system }:
    {
        mkBashDevShell = { name, packages ? [], env ? {}, shellHook ? "", }: pkgs.mkShell {
            name = "${name}";
            packages = packages;
            env = {
                SH = "bash";
                DEVSHELL = name;
            } // env;
            shellHook = shellHook;
        };
    };
}