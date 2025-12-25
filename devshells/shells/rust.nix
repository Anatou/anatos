{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "rust";
    #overrides = (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml));

in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "rust";
        packages = with pkgs; [ 
            #clippy
            #rustc
            stdenv
            cargo
            rustup
            rustPlatform.bindgenHook
            #rustfmt
            openssl
            pkg-config
            cargo-deny
            cargo-edit
            cargo-watch
            rust-analyzer
        ];
        beforeZsh = ''
            export PATH="''${CARGO_HOME:-$HOME/.cargo}/bin":"$PATH"
            export PATH="''${RUSTUP_HOME:-$HOME/.rustup}/toolchains/$RUSTC_VERSION-${pkgs.stdenv.hostPlatform.rust.rustcTarget}/bin":"$PATH"
            devshell fhs
            exit
        '';
        env = {
            #RUSTC_VERSION = overrides.toolchain.channel;
            # Required by rust-analyzer
            #RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
        };
    };
}