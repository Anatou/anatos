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
            export PATH="$FRSCSDK/bin:$PATH"
        '';
    };
}