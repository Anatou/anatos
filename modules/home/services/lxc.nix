{ pkgs, lib, config, nixosConfig, ... }:
{

    options.my.home.services.lxc.enable = lib.mkEnableOption "Enable lxc";

    config = lib.mkIf config.my.home.services.lxc.enable {
        assertions =
        [ { assertion = nixosConfig.virtualisation.lxc.enable;
            message = "virtualisation.lxc.enable must be set to `true` on system level for lxc to work";
            }
        ];

        home.file.".config/lxc/default.conf".text = ''
            lxc.net.0.type = veth
            lxc.net.0.link = lxcbr0
            lxc.net.0.flags = up
            lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
            lxc.idmap = u 0 100000 65536
            lxc.idmap = g 0 100000 65536
        '';
    };
}



