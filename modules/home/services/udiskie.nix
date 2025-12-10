{ pkgs, lib, config, nixosConfig, ... }:
{

    options.my.home.services.udiskie.enable = lib.mkEnableOption "Enable udiskie";

    config = lib.mkIf config.my.home.services.udiskie.enable {
        assertions =
        [ { assertion = nixosConfig.services.udisks2.enable;
            message = "services.udisks2.enable must be set to `true` on system level for udiskie to work";
            }
        ];

        # services.udisks2.enable = true; must be set in system config
        services.udiskie = {
            enable = true;
            settings = {
                # workaround for
                # https://github.com/nix-community/home-manager/issues/632
                program_options = {
                    # replace with your favorite file manager
                    file_manager = "${pkgs.yazi}/bin/yazi";
                };
            };
        };
    };
}



