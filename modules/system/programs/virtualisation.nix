{ lib, config, pkgs, ...}:

{
    options.my.system.programs.virtualisation.enable = lib.mkEnableOption "Enable useful virtualisation options";

    config = lib.mkIf config.my.system.programs.virtualisation.enable {
        virtualisation = {
            docker.enable = true;
            podman.enable = true;

            libvirtd.enable = true;

            virtualbox.host = {
                enable = true;
                enableExtensionPack = true;
            };
            virtualbox.guest.enable = true;
        };

        programs = {
            virt-manager.enable = true;
        };

        environment.systemPackages = with pkgs; [
            virt-viewer
            lazydocker
            docker-client
            virtualbox 
        ];
    };
}