{ lib, config, pkgs, ...}:

{
    options.my.home.programs.rofimoji.enable = lib.mkEnableOption "Enable my rofimoji configuration";

    config = lib.mkIf config.my.home.programs.rofimoji.enable {
        home.packages = with pkgs; [
            rofimoji
            (pkgs.writeShellScriptBin "rofimoji-cfg" "rofimoji -a type -f emojis latin-1 math")
        ];
        # All extension files are @${pkgs.rofimoji}/lib/python3.12/site-packages/picker/data/
    };
}