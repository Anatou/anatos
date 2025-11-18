{ pkgs, ... }:
pkgs.writeShellScriptBin "devshell" ''
    DEVSHELLFLAKE="$HOME/anatos/modules/devshells/#"
    
    print_help() {
        echo "Available devshells are"
        echo "- c"
        echo "- python"
        echo "- python-no-venv"
    }

    if [[ ! -n "$1" ]]; then
        echo "No option specified, you must choose which devshell to activate"
        print_help
        exit
    fi

    flake=$(echo "$DEVSHELLFLAKE$1")
    nix develop "$flake"
    ''