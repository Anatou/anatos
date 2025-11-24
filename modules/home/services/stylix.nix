{ pkgs, lib, config, ... }:
{

    options.my.home.services.stylix.enable = lib.mkEnableOption "Enable stylix";

    config = lib.mkIf config.my.home.services.stylix.enable {
        home.packages = with pkgs; [
            base16-schemes
        ];
        stylix = {
            enable = true;
            polarity = "dark";
            base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";

            targets = {
                "hyprlock".enable = false;
                "vscode".enable = false;
            };

            fonts = {
                serif = {
                    package = pkgs.dejavu_fonts;
                    name = "DejaVu Serif";
                };

                sansSerif = {
                    package = pkgs.dejavu_fonts;
                    name = "DejaVu Sans";
                };

                monospace = {
                    package = pkgs.fira-code;
                    name = "Firacode";
                };

                emoji = {
                    package = pkgs.noto-fonts-color-emoji;
                    name = "Noto Color Emoji";
                };
            };
        };
    };
}



