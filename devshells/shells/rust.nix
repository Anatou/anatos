{ pkgs, system, ...}:
let
    mkZshDevshell = (import ../lib/zsh-devshell.nix) { inherit pkgs; };
    prefix = "rust";
in
{ 
    default = {
        prefix = prefix;
        function = mkZshDevshell;
        name = "rust";
        packages = with pkgs; [ 
            clippy
            rustc
            cargo
            rustfmt
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
}