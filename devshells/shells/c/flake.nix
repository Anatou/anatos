{
    description = "A generic C development shell";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        mk-devshells = (import ../../lib/zsh-devshell.nix).outputs { inherit self nixpkgs system; };
        mkZshDevShell = mk-devshells.mkZshDevShell;
    in 
    {
        devShells.${system} = {
            default = mkZshDevShell {
                name = "c";
                packages = with pkgs; [
                    libgcc
                    cmake
                    clang-tools
                    gdb
                    valgrind-light
                ];
            }
        };
    };
}
