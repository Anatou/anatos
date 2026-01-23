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
            rustup
            stdenv
            rustPlatform.bindgenHook

            openssl
            pkg-config
            libevdev
            fontconfig
            rust-analyzer

            libxkbcommon
            wayland
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            libGL

            gcc
        ];
        beforeZsh = ''
            export PATH="''${CARGO_HOME:-$HOME/.cargo}/bin":"$PATH"
            export PATH="''${RUSTUP_HOME:-$HOME/.rustup}/toolchains/$RUSTC_VERSION-${pkgs.stdenv.hostPlatform.rust.rustcTarget}/bin":"$PATH"
            # devshell fhs
            # exit
        '';
        env = {
            #RUSTC_VERSION = overrides.toolchain.channel;
            # Required by rust-analyzer
            #RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
        };
    };
}