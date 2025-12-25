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
            if [[ -v DEVSHELL ]]; then
                export name="''\${DEVSHELL}-fhs-env"
            else    
                export DEVSHELL=${name}
            fi
            zsh
        '';
    };
}