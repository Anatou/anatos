{ pkgs, ...}:
let
    libs = import ./libs.nix { inherit pkgs; };
in
{ name, packages ? [], environment ? {}, use-venv ? true, function, prefix}: pkgs.mkShell {
    name = "${name}";
    packages = packages;
    env = {
        SH = "zsh";
        DEVSHELL = "${name}";
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
    ${venv-setup}
    exec $SH
    deactivate
    '';
}