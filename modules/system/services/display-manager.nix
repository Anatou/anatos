{ lib, config, pkgs, ...}:
let
  sddm-astronaut = pkgs.sddm-astronaut;
in
{
  options.my.system.services.sddm.enable = lib.mkEnableOption "Enable my sddm configuration";

  config = lib.mkIf config.my.system.services.sddm.enable {
    services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        extraPackages = [sddm-astronaut];
        enable = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
    };

    environment.systemPackages = [sddm-astronaut];

  };
}