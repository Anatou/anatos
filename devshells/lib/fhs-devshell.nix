{ pkgs, ...}:
let 
    libs = (import ./libs.nix) { inherit pkgs; };
    make-devshell-name = (import ./make-devshell-name.nix);
in
{ name, packages ? [], multiArch ? false, multiPkgs ? (_: []), beforeZsh ? "", ... }: pkgs.buildFHSEnv {
    inherit name multiArch multiPkgs;
    targetPkgs = pkgs: (packages ++ libs);
    runScript = pkgs.writeTextFile {
        name = "startFHS";
        executable = true;
        text = ''
            ${make-devshell-name name}
            ${beforeZsh}
            zsh
        '';
    };
}