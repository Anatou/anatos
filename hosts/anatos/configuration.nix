{ config, lib, pkgs, inputs, system, username, host, ... }:

{
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

    # Use systemd-boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    #boot.initrd.kernelModules = [ "mt7921e" ];
    #environment.systemPackages = with pkgs; [ linux-firmware ];


    # Wireless and networking
    networking.hostName = "${host}";
    my.system.services.wireless.enable = true;
    my.system.services.openssh.enable = true;

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

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Kernel options
    boot.kernelPackages = pkgs.linuxPackages_zen;
    #boot.kernelPackages = pkgs.linuxPackages_latest;
    
    # Boot options
    my.system.services.displayManager = "ly";
    my.system.services.splashscreen.enable = false;

    # Driver
    hardware.cpu.amd.updateMicrocode = true;
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    #services.xserver.enable = true;
    #boot.initrd.kernelModules = [ "amdgpu" ];

    # Audio
    my.system.services.pipewire.enable = true;

    # Fonts
    my.system.services.fonts.default.enable = true;

    # Programs configuration
    my.system.programs.base-programs.enable = true;
    services.hardware.openrgb.enable = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "24.11"; # Did you read the comment?
}

