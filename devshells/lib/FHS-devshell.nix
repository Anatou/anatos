{
    description = "A function creating a devshell with bash";

    outputs = { self, pkgs, system }:
    {
        mkFHSDevShell = { name, packages ? []}: pkgs.buildFHSEnv {
            name = "${name}";
            targetPkgs = pkgs: (packages);
            runScript = pkgs.writeTextFile {
                name = "startFHS";
                executable = true;
                text = ''
                    export DEVSHELL=${name}
                    zsh
                '';
            };
        };
    };
}