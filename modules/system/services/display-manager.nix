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
      services.displayManager.ly = {
        enable = true;
        settings = {
            clock = "%c";
            battery_id = "BAT_0";
            box_title = "Hello !";
            lang = "fr";
        };
      };
    })
  ];
}
