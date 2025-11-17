{ pkgs, lib, config, ... }:
{

    options.my.home.services.wayland-screenshot.enable = lib.mkEnableOption "Enable wayland-screenshot";

    config = lib.mkIf config.my.home.services.wayland-screenshot.enable {
        home.packages = [
            pkgs.grim
            pkgs.swappy
            pkgs.slurp
            (pkgs.writeShellScriptBin "wayland-screenshot" ''
            grim -g "$(slurp)" - | swappy -f -
            '')
        ];
    };
}



