{ pkgs, ...}:
let 
    libs = (import ./libs.nix) { inherit pkgs; };
    make-devshell-name = (import ./make-devshell-name.nix);
in
{ name, packages ? []}: pkgs.buildFHSEnv {
    name = "${name}";
    targetPkgs = pkgs: (packages ++ libs);
    runScript = pkgs.writeTextFile {
        name = "startFHS";
        executable = true;
        text = ''
            ${make-devshell-name name}
            zsh
        '';
    };
}