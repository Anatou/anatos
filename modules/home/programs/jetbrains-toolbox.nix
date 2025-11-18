{ lib, config, pkgs, ...}:

{
    options.my.home.programs.jetbrains-toolbox.enable = lib.mkEnableOption "Enable my jetbrains-toolbox configuration";

    config = lib.mkIf config.my.home.programs.jetbrains-toolbox.enable {
        home.packages = with pkgs; [
            jetbrains-toolbox
        ];
        # home.sessionPath = [
        #     "$HOME/.local/share/JetBrains/Toolbox/scripts"
        # ];
    };
}