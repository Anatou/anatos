{ lib, config, pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut;
in
{
  options.my.system.services.displayManager = lib.mkOption {
    type = lib.types.enum [ "sddm" "gdm" "ly" "none" ];
    default = "none";
    description = "Choose your display manager (sddm, gdm, ly, none)";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.my.system.services.displayManager == "sddm") {
      services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        extraPackages = [ sddm-astronaut ];
        enable = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
      };

      environment.systemPackages = [ sddm-astronaut ];
    })

    (lib.mkIf (config.my.system.services.displayManager == "gdm") {
      services.xserver.displayManager.gdm = {
        enable = true;
        banner = "Hello !";
        wayland = true;
      };
    })

    (lib.mkIf (config.my.system.services.displayManager == "ly") {
    # See options https://github.com/fairyglade/ly/blob/v1.3.x/res/config.ini
      services.displayManager.ly = {
        enable = true;
        settings = {
            clock = "%A %e %B %Y - %R";
            lang = "fr";
            box_title = "Hello User !";
            
            battery_id = "BAT1";
            session_log = ".local/ly/ly-session.log";
            brightness_down_key = "F4";
            brightness_up_key = "F5";

            animation = "matrix";
            # 12288-12543 for japanese text but its broken
            # Or 48-49 for only 0 and 1
            cmatrix_min_codepoint = 48;
            cmatrix_max_codepoint = 50;
        };
      };
    })
  ];
}
