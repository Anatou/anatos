{
    description = "Flake containing many python development shells";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        mk-py-devshells = (import ../../lib/python-zsh-devshell.nix).outputs { inherit self pkgs system; };
        mkPythonDevShell = mk-py-devshells.mkPythonDevShell;
        mk-bash-devshells = (import ../../lib/bash-devshell.nix).outputs { inherit self pkgs system; };
        mkBashDevShell = mk-bash-devshells.mkBashDevShell;
    in 
    {
        devShells.${system} = {
            default = mkPythonDevShell {
                version = "3.13";
                packages = with pkgs; [ python313 ];
            };

            no-venv = mkPythonDevShell {
                version = "3.13-no-venv";
                packages = with pkgs; [ python313 ];
                use-venv = false;
            };

            shell = mkBashDevShell {
                name = "python3.13-shell";
                packages = with pkgs; [
                    python313
                ];
                shellHook = "python; exit";
            };
        };
    };
}

#(python313.withPackages (p: [ p.pyzmq p.ipykernel p.jupyterlab p.jupyter ]))
