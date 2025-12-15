{ config, lib, pkgs, host, ... }:

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
    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.loader.grub.device = "nodev"; 

    my.system.services.displayManager = "ly";
    my.system.services.splashscreen.enable = true;

    # =============== System services =============== #
    # Wireless and networking
    networking.hostName = "${host}";
    my.system.services.wireless.enable = true;
    my.system.services.openssh.enable = true;
    my.system.services.pipewire.enable = true;
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

    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.05"; # Did you read the comment?

}

