{
    description = "A generic prolog development shell";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        mk-devshells = (import ../../lib/zsh-devshell.nix).outputs { inherit self pkgs system; };
        mkZshDevShell = mk-devshells.mkZshDevShell;
    in 
    {
        devShells.${system} = {
            default = mkZshDevShell {
                name = "prolog";
                packages = with pkgs; [ 
                    swi-prolog
                ];
            };
        };

        #packages.${system}.default = {
        #    packages = with pkgs; [
        #        swi-prolog
        #    ];
        #};
    };
}