{ lib, config, pkgs, ...}:

{
    options.my.system.services.wireless.enable = lib.mkEnableOption "Enable and configure wireless services";

    config = lib.mkIf config.my.system.services.wireless.enable {
        services.blueman.enable = true;
        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = false;

        networking.networkmanager.enable = true;
		networking.networkmanager.plugins = with pkgs; [
			networkmanager-fortisslvpn
			networkmanager-iodine
			networkmanager-l2tp
			networkmanager-openconnect
			networkmanager-openvpn
			networkmanager-sstp
			networkmanager-strongswan
			networkmanager-vpnc
		];
        environment.systemPackages = with pkgs; [
            networkmanagerapplet
        ];
    };
}