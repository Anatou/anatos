{ pkgs, ...}:
let 
    libs = (import ./libs.nix) { inherit pkgs; };
    make-devshell-name = (import ./make-devshell-name.nix);
    make-zdotdir = (import ./make-zdotdir.nix) { inherit pkgs; };
in
{ name, packages ? [], multiArch ? false, multiPkgs ? (_: []), beforeZsh ? "", zshrc ? "", ... }: pkgs.buildFHSEnv {
    inherit name multiArch multiPkgs;
    targetPkgs = pkgs: (packages ++ libs);
    runScript = pkgs.writeTextFile {
        name = "startFHS";
        executable = true;
        text = ''
            ${make-devshell-name name}
            ${beforeZsh}
            export ZDOTDIR=${make-zdotdir name zshrc}
            zsh
        '';
    };
}