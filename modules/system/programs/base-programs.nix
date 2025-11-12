{ lib, config, pkgs, ...}:

{
    options.my.system.programs.base-programs.enable = lib.mkEnableOption "Installs useful system programs";

    config = lib.mkIf config.my.system.programs.base-programs.enable {
        environment.systemPackages = with pkgs; [
            # GUI programs
            firefox
            kitty
            # TUI programs
            zsh
            vim 
            wget
            git
            ffmpeg
            htop
            btop
            usbutils
            unrar
            unzip
            killall
            pciutils
            appimage-run
            libnotify
            acpi
        ];
        programs.adb.enable = true;
    };
}