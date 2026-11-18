{ pkgs, ...}:
let
    libs = import ./libs.nix { inherit pkgs; };
    make-devshell-name = (import ./make-devshell-name.nix);
    make-zdotdir = (import ./make-zdotdir.nix) { inherit pkgs; };
in
{ name, packages ? [], env ? {}, beforeZsh ? "", afterZsh ? "", zshrc ? "", function, prefix }: pkgs.mkShell {
    name = "${name}";
    packages = packages;
    env = {
        SH = "zsh";
        LD_LIBRARY_PATH= "${pkgs.lib.makeLibraryPath libs}";
    } // env;
    shellHook = ''${make-devshell-name name}'' +
    beforeZsh + ''
        export ZDOTDIR=${make-zdotdir name zshrc}
        exec $SH
    '' + afterZsh;
}

# NOTE
# If a other .zshrc is sourced, it must contain
# source ~/.zshrc
# RPROMPT=$RPROMPT"%F{red}["$DEVSHELL"]%f"
# And the shellHook must contain
# export ZDOTDIR="$HOME/anatos/modules/devshells" #important, does not work from env