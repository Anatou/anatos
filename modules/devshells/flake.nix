{
    description = "A flake containing many development shells";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    outputs = { self, nixpkgs }:
        let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        mkZshDevShell = { devshellTitle, packages ? [], env ? {}, beforeZsh ? "", afterZsh ? "" }: pkgs.mkShell {
            name = "${devshellTitle}";
            packages = packages;
            env = {
                SH = "zsh";
                DEVSHELL = devshellTitle;
            } // env;
            shellHook = beforeZsh + ''
                exec $SH
            '' + afterZsh;
            # If a other .zshrc is sourced, it must contain
            # source ~/.zshrc
            # RPROMPT=$RPROMPT"%F{red}["$DEVSHELL"]%f"
            # And the shellHook must contain
            # export ZDOTDIR="$HOME/anatos/modules/devshells" #important, does not work from env
        };

        mkBashDevShell = { devshellTitle, packages ? [], env ? {}, shellHook ? "", }: pkgs.mkShell {
            name = "${devshellTitle}";
            packages = packages;
            env = {
                DEVSHELL = devshellTitle;
            } // env;
            shellHook = shellHook;
        };
        in 
        {
        devShells.${system} = {
            c = mkZshDevShell {
                devshellTitle = "c";
                packages = with pkgs; [
                    libgcc
                    cmake
                    clang-tools
                    gdb
                    valgrind-light
                ];
            };

            java = mkZshDevShell {
                devshellTitle = "java";
                packages = with pkgs; [
                    jdk
                    maven
                    gradle
                ];
            };

            python = mkZshDevShell {
                devshellTitle = "python";
                packages = with pkgs; [
                    python314
                ];
                beforeZsh = ''
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
                '';
                afterZsh = ''
                    deactivate
                '';
            };
            python-no-venv = mkZshDevShell {
                devshellTitle = "python-no-venv";
                packages = with pkgs; [
                    python314
                ];
            };
            python-shell = mkBashDevShell {
                devshellTitle = "python-shell";
                packages = with pkgs; [
                    python314
                ];
                shellHook = "python; exit";
            };
        };
    };
}
