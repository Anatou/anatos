{ pkgs, ...}:
let
    libs = import ./libs.nix { inherit pkgs; };
    make-devshell-name = (import ./make-devshell-name.nix);
    make-zdotdir = (import ./make-zdotdir.nix) { inherit pkgs; };
in
{ name, packages ? [], environment ? {}, use-venv ? true, zshrc ? "", function, prefix}: pkgs.mkShell {
    name = "${name}";
    packages = packages ++ [pkgs.ninja];
    env = {
        SH = "zsh";
        LD_LIBRARY_PATH= "${pkgs.lib.makeLibraryPath libs}";
    } // environment;
    shellHook = let 
        venv-setup = if use-venv then
        ''
        if [ ! -d ./.venv ]; then 
            echo "There is no python virtual environment in this directory, would you like to create one ?"
            echo "You can start a python devshell with no virtual environment with the python-no-venv option"
            read -p "(y/n) > " choice
            case "$choice" in
                y|Y ) python -m venv .venv;;
                n|N ) echo "Exiting devshell"; exit;;
                * ) echo "Invalid choice, exiting"; exit;;
            esac
        fi
        source .venv/bin/activate
        ''
        else "";
    in
    ''
    ${make-devshell-name name}
    ${venv-setup}
    export ZDOTDIR=${make-zdotdir name zshrc}
    exec $SH
    deactivate
    '';
}