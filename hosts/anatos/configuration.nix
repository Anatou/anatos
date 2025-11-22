{ config, lib, pkgs, inputs, system, username, host, pkgs-linux-firmware-downgrade, ... }:

{
    # =============== Nix settings =============== #
    imports =
        [ # Include the results of the hardware scan.
        ./hardware.nix
        ./../../modules/system
        ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Nix package options
    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;

    nix.settings.auto-optimise-store = true;
    nix.gc = {
        automatic = true;
        dates = "weekly";
    };

    # =============== Boot & Kernel settings =============== #
    # Boot options
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    my.system.services.displayManager = "ly";
    my.system.services.splashscreen.enable = true;
    hardware.firmware = [ pkgs-linux-firmware-downgrade.linux-firmware ];

    # Kernel options
    boot.kernelPackages = pkgs.linuxPackages_zen;

    # Driver
    hardware.cpu.amd.updateMicrocode = true;
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };
    hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    # =============== System services =============== #
    # Wireless and networking
    networking.hostName = "${host}";
    my.system.services.wireless.enable = true;
    my.system.services.openssh.enable = true;

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Audio
    my.system.services.pipewire.enable = true;

    # Fonts
    my.system.services.fonts.default.enable = true;

    # =============== System language =============== #
    # Select internationalisation properties.
    time.timeZone = "Europe/Paris";
    i18n.defaultLocale = "fr_FR.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = lib.mkForce "fr";
        useXkbConfig = true; # use xkb.options in tty.
    };
    services.xserver.xkb.layout = "fr";
    services.xserver.xkb.options = "eurosign:e,caps:escape";

    # =============== System programs =============== #
    my.system.programs.base-programs.enable = true;
    services.hardware.openrgb.enable = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # Most users should NEVER change this value after the initial install, for any reason,
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "24.11"; # Did you read the comment?
}

