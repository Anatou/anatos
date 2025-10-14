{ lib, ...}:
{
    options.programs.hyprland.enable = lib.mkEnableOption "Enable Hyprland";

    config = lib.mkIf config.windowManager.hyprland.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            package = pkgs.hyprland;
            systemd = {
                enable = true;
                enableXdgAutostart = true;
                variables = [ "--all" ];
            };
            xwayland.enable = true;
        }
    }
}