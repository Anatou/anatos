{ lib, config, ...}:

{
    options.my.home.programs.zoxide.enable = lib.mkEnableOption "Enable my zoxide configuration";

    config = lib.mkIf config.my.home.programs.zoxide.enable {
        programs.zoxide = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
            options = [
              "--cmd cd"
            ];
        };
    };
}