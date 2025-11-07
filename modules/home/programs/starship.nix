{ lib, config, pkgs, ...}:

{
    options.my.home.programs.starship.enable = lib.mkEnableOption "Enable my starship configuration";

    config = lib.mkIf config.my.home.programs.starship.enable {
        programs.starship = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
            settings = {
                nix_shell = {
                    "format" = "via [$symbol$name\($state\)]($style)";
                };
            };
        };
    };
}