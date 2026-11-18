{ pkgs, system, ...}:
let
    mkFHSDevShell = (import ../lib/fhs-devshell.nix) { inherit pkgs; };
    prefix = "pocketbook";
in
{
    default = {
        prefix = prefix;
        function = args: (mkFHSDevShell args).env;
        name = "pocketbook";
        packages = with pkgs; [ gnumake ];
        multiArch = true;
        multiPkgs = p: with p; [ glibc zlib ];
        beforeZsh = ''
            export FRSCSDK="''${FRSCSDK:-$HOME/documents/informatique/pocketbook_626_dev/pocketbook-sdk/FRSCSDK}"
            export SDK="$FRSCSDK"
            export PBSDK="$FRSCSDK"
            export PATH="$FRSCSDK/bin:$PATH"
            export PBAPPS="$HOME/documents/informatique/pocketbook_626_dev/applications"
            export DEBUGBIN="$HOME/documents/informatique/pocketbook_626_dev/pocketbook-sdk/SDK_481/bin"
        '';
        zshrc = ''
            alias pbg++="$FRSCSDK/bin/arm-none-linux-gnueabi-g++"
            alias pbgdb="$DEBUGBIN/arm-obreey-linux-gnueabi-gdb"
            alias app-send="$PBAPPS/app-send"
        '';
    };
}