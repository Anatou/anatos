{ lib, config, pkgs, nixosConfig, ...}:

{
    options.my.home.programs.thunar.enable = lib.mkEnableOption "Enable my thunar configuration";

    config = lib.mkIf config.my.home.programs.thunar.enable {
        assertions = [ 
            { assertion = nixosConfig.programs.xfconf.enable;
              message = "programs.xfconf.enable must be set to `true` on system level for thunar to work";
            }
            { assertion = nixosConfig.services.gvfs.enable;
              message = "services.gvfs.enable must be set to `true` on system level for thunar to work";
            }
            { assertion = nixosConfig.services.tumbler.enable;
              message = "services.tumbler.enable must be set to `true` on system level for thunar to work";
            }
        ];
        home.packages = with pkgs; [
            thunar
            thunar-volman
            thunar-dropbox-plugin
            thunar-vcs-plugin
            thunar-archive-plugin
            thunar-media-tags-plugin
        ];
    };
}