{
    description = "A generic rust development shell";

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
                name = "rust";
                packages = with pkgs; [ 
                    clippy
                    rustc
                    cargo
                    rustfmt
                    #rust-src
                    openssl
                    pkg-config
                    cargo-deny
                    cargo-edit
                    cargo-watch
                    rust-analyzer
                ];
                #env = {
                #    # Required by rust-analyzer
                #    RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
                #};
            };
        };
    };
}