{
    description = "A flake containing many development shells";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        # Importing the flakes helps pinning the software ?
        c = {
            url = "path:./shells/c";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        python = {
            url = "path:./shells/python";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        rust = {
            url = "path:./shells/rust";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        DEVSHELLSDIR="$HOME/anatos/devshells/shells";
    in 
    {
        devshell = pkgs.writeShellScriptBin "devshell"
            ''
                declare -A flakes=()
                
                for dir in "$HOME"/anatos/devshells/shells/*/; do
                    flake_name=$(basename "$dir")
                    cd "$dir"
                    flake_shells_raw=$(nix flake show --quiet --no-warn-dirty --no-write-lock-file --no-update-lock-file)

                    IFS=$'\n' read -rd ''\'' -a flake_shells_splitted <<< "$flake_shells_raw"
                    flake_shells=("''\${flake_shells_splitted[@]:3}")
                    flake_shells_str=""
                    for i in $(seq 0 ''\${#flake_shells[@]}); do
                        flake_shells_str="$flake_shells_str''\${flake_shells[$i]:14}\n"
                    done
                    flake_shells_str=''\${flake_shells_str::-2}
                    if [ ''\${#flake_shells[@]} -gt 1 ]; then
                        flake_name="$flake_name (''\${#flake_shells[@]} devshells)"
                    else
                        flake_name="$flake_name (''\${#flake_shells[@]} devshell)"
                    fi
                    flakes["$flake_name"]=''\${flake_shells_str}
                done

                out_str=""
                out_str="$out_str======== ''\${#flakes[@]} development flakes ========\n"
                for el in "''\${!flakes[@]}"; do
                    out_str="$out_str\x1B[32m$el\x1B[0m\n"
                    out_str="$out_str''\${flakes["''\${el}"]}"
                done
                echo -e "$out_str"
            '';
        };
}
