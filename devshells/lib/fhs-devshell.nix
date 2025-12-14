{ pkgs, ...}:
let 
    libs = (import ./libs.nix) { inherit pkgs; };
in
{ name, packages ? []}: pkgs.buildFHSEnv {
    name = "${name}";
    targetPkgs = pkgs: (packages ++ libs);
    runScript = pkgs.writeTextFile {
        name = "startFHS";
        executable = true;
        text = ''
            export DEVSHELL=${name}
            zsh
        '';
    };
}