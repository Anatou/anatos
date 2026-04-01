{ lib, config, pkgs, pkgs-old, username, ...}:

{
    options.my.system.programs.virtualisation.docker.enable = lib.mkEnableOption "Enable docker";
    options.my.system.programs.virtualisation.podman.enable = lib.mkEnableOption "Enable podman";
    options.my.system.programs.virtualisation.libvirt.enable = lib.mkEnableOption "Enable libvirtd";
    options.my.system.programs.virtualisation.lxc.enable = lib.mkEnableOption "Enable lxc";
    options.my.system.programs.virtualisation.virtualbox.enable = lib.mkEnableOption "Enable virtualbox";
    options.my.system.programs.virtualisation.virtualbox-retro.enable = lib.mkEnableOption "Enable virtualbox 5.2 (old)";
    options.my.system.programs.virtualisation.vmware-client.enable = lib.mkEnableOption "Enable vmware client";
    
    config = lib.mkMerge [
        (lib.mkIf config.my.system.programs.virtualisation.docker.enable {
            virtualisation.docker.enable = true;
            environment.systemPackages = with pkgs; [
                lazydocker
                docker-client
            ];
        })
        (lib.mkIf config.my.system.programs.virtualisation.podman.enable {
            virtualisation.podman.enable = true;
        })
        (lib.mkIf config.my.system.programs.virtualisation.libvirt.enable {
            virtualisation = {
                libvirtd.enable = true;
                libvirtd.qemu.package = pkgs.qemu_full;
            };
            programs = { virt-manager.enable = true; };
            environment.systemPackages = with pkgs; [ virt-viewer ];
        })
        (lib.mkIf config.my.system.programs.virtualisation.vmware-client.enable {
            virtualisation.vmware.guest.enable = true;
            virtualisation.vmware.guest.headless = false;
        })
        (lib.mkIf config.my.system.programs.virtualisation.lxc.enable {
            virtualisation = {
                lxc = {
                    enable = true;
                    unprivilegedContainers = true;
                    # defaultConfig = ''
                    #     lxc.idmap = u 0 100000 65536
                    #     lxc.idmap = g 0 100000 65536
                    # '';
                };
            };
            #system.activationScripts.script.text = 
            environment.etc."subuid".text = "${username}:100000:65536\n";
            environment.etc."subgid".text = "${username}:100000:65536\n";
            environment.etc."lxc/lxc-usernet".text = "${username} veth lxcbr0 10\n";
        })
        (lib.mkIf config.my.system.programs.virtualisation.virtualbox.enable {
            virtualisation = {
                virtualbox.host = {
                    enable = true;
                    enableExtensionPack = true;
                };
                virtualbox.guest.enable = true;
            };
        })
        (lib.mkIf config.my.system.programs.virtualisation.virtualbox-retro.enable {
            virtualisation = {
                virtualbox.host = {
                    package = pkgs-old.virtualbox;
                    enable = true;
                    enableExtensionPack = true;
                };
                virtualbox.guest.enable = true;
            };
        })
    ];
}