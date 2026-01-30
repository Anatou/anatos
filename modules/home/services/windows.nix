{ pkgs, lib, config, nixosConfig, system, winapps, username, ... }:
{

    options.my.home.services.windows = {
        enable = lib.mkEnableOption "Enable windows";
        disk-location = lib.mkOption {
            type = lib.types.str;
            default = "/home/${username}/windows";
            description = "Set a path for the windows disk location (ex /home/user/windows)";
        };
        username = lib.mkOption {
            type = lib.types.str;
            default = "${username}";
            description = "Sets the windows username";
        };
        password = lib.mkOption {
            type = lib.types.str;
            default = "${username}";
            description = "Sets the windows password";
        };
        use-winapps = lib.mkEnableOption "Wether to use winapps";
    };

    config = lib.mkIf config.my.home.services.windows.enable {
        assertions =
        [ { assertion = nixosConfig.virtualisation.docker.enable;
            message = "virtualisation.docker.enable must be set to `true` on system level for windows to work";
            }
          { assertion = nixosConfig.virtualisation.libvirtd.enable;
            message = "virtualisation.libvirtd.enable must be set to `true` on system level for windows to work";
            }
        ];

        home.packages = [
            pkgs.freerdp
        ] 
        ++ lib.optionals (config.my.home.services.windows.use-winapps) [
            winapps.packages."${system}".winapps
            winapps.packages."${system}".winapps-launcher
        ];

        # /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\
        #  Windows password are stored in clear in this configuration, do not use windows for a secured purpose
        # /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\

        home.shellAliases = {
            windows="docker compose --file ~/.config/winapps/compose.yaml";
            rdpwin="xfreerdp /u:\"${config.my.home.services.windows.username}\" /p:\"${config.my.home.services.windows.password}\" /v:127.0.0.1 /cert:tofu";
        };

        home.file.".config/winapps/winapps.conf".text = if config.my.home.services.windows.use-winapps then ''
            ##################################
            #   WINAPPS CONFIGURATION FILE   #
            ##################################

            # INSTRUCTIONS
            # - Leading and trailing whitespace are ignored.
            # - Empty lines are ignored.
            # - Lines starting with '#' are ignored.
            # - All characters following a '#' are ignored.

            # [WINDOWS USERNAME]
            RDP_USER="${config.my.home.services.windows.username}"

            # [WINDOWS PASSWORD]
            # NOTES:
            # - If using FreeRDP v3.9.0 or greater, you *have* to set a password
            RDP_PASS="${config.my.home.services.windows.password}"

            # [WINDOWS DOMAIN]
            # DEFAULT VALUE: "" (BLANK)
            RDP_DOMAIN=""

            # [WINDOWS IPV4 ADDRESS]
            # NOTES:
            # - If using 'libvirt', 'RDP_IP' will be determined by WinApps at runtime if left unspecified.
            # DEFAULT VALUE:
            # - 'docker': '127.0.0.1'
            # - 'podman': '127.0.0.1'
            # - 'libvirt': "" (BLANK)
            RDP_IP="127.0.0.1"

            # [VM NAME]
            # NOTES:
            # - Only applicable when using 'libvirt'
            # - The libvirt VM name must match so that WinApps can determine VM IP, start the VM, etc.
            # DEFAULT VALUE: 'RDPWindows'
            VM_NAME="RDPWindows"

            # [WINAPPS BACKEND]
            # DEFAULT VALUE: 'docker'
            # VALID VALUES: 'docker' 'podman' 'libvirt' 'manual'
            WAFLAVOR="docker"

            # [DISPLAY SCALING FACTOR]
            # NOTES:
            # - If an unsupported value is specified, a warning will be displayed.
            # - If an unsupported value is specified, WinApps will use the closest supported value.
            # DEFAULT VALUE: '100'
            # VALID VALUES: '100' '140' '180'
            RDP_SCALE="100"

            # [MOUNTING REMOVABLE PATHS FOR FILES]
            # NOTES:
            # - By default, `udisks` (which you most likely have installed) uses /run/media for mounting removable devices.
            #   This improves compatibility with most desktop environments (DEs).
            # ATTENTION: The Filesystem Hierarchy Standard (FHS) recommends /media instead. Verify your system's configuration.
            # - To manually mount devices, you may optionally use /mnt.
            # REFERENCE: https://wiki.archlinux.org/title/Udisks#Mount_to_/media
            REMOVABLE_MEDIA="/run/media"

            # [ADDITIONAL FREERDP FLAGS & ARGUMENTS]
            # NOTES:
            # - You can try adding /network:lan to these flags in order to increase performance, however, some users have faced issues with this.
            #   If this does not work or if it does not work without the flag, you can try adding /nsc and /gfx.
            # DEFAULT VALUE: '/cert:tofu /sound /microphone +home-drive'
            # VALID VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
            RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"

            # [NON FULL WINDOWS RDP FLAGS]
            # NOTES:
            # - Use these flags to pass specific flags to the freerdp command when you are starting a non-full RDP session (any other command than winapps windows)
            # DEFAULT_VALUES: ""
            # VALID_VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
            RDP_FLAGS_NON_WINDOWS=""

            # [FULL WINDOWS RDP FLAGS]
            # NOTES:
            # - Use these flags to pass specific flags to the freerdp command when you are starting a full RDP session (winapps windows)
            # DEFAULT_VALUES: ""
            # VALID_VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
            RDP_FLAGS_WINDOWS=""

            # [DEBUG WINAPPS]
            # NOTES:
            # - Creates and appends to ~/.local/share/winapps/winapps.log when running WinApps.
            # DEFAULT VALUE: 'true'
            # VALID VALUES:
            # - 'true'
            # - 'false'
            DEBUG="true"

            # [AUTOMATICALLY PAUSE WINDOWS]
            # NOTES:
            # - This is currently INCOMPATIBLE with 'manual'.
            # DEFAULT VALUE: 'off'
            # VALID VALUES:
            # - 'on'
            # - 'off'
            AUTOPAUSE="off"

            # [AUTOMATICALLY PAUSE WINDOWS TIMEOUT]
            # NOTES:
            # - This setting determines the duration of inactivity to tolerate before Windows is automatically paused.
            # - This setting is ignored if 'AUTOPAUSE' is set to 'off'.
            # - The value must be specified in seconds (to the nearest 10 seconds e.g., '30', '40', '50', etc.).
            # - For RemoteApp RDP sessions, there is a mandatory 20-second delay, so the minimum value that can be specified here is '20'.
            # - Source: https://techcommunity.microsoft.com/t5/security-compliance-and-identity/terminal-services-remoteapp-8482-session-termination-logic/ba-p/246566
            # DEFAULT VALUE: '300'
            # VALID VALUES: >=20
            AUTOPAUSE_TIME="300"

            # [FREERDP COMMAND]
            # NOTES:
            # - WinApps will attempt to automatically detect the correct command to use for your system.
            # DEFAULT VALUE: "" (BLANK)
            # VALID VALUES: The command required to run FreeRDPv3 on your system (e.g., 'xfreerdp', 'xfreerdp3', etc.).
            FREERDP_COMMAND=""

            # [TIMEOUTS]
            # NOTES:
            # - These settings control various timeout durations within the WinApps setup.
            # - Increasing the timeouts is only necessary if the corresponding errors occur.
            # - Ensure you have followed all the Troubleshooting Tips in the error message first.

            # PORT CHECK
            # - The maximum time (in seconds) to wait when checking if the RDP port on Windows is open.
            # - Corresponding error: "NETWORK CONFIGURATION ERROR" (exit status 13).
            # DEFAULT VALUE: '5'
            PORT_TIMEOUT="5"

            # RDP CONNECTION TEST
            # - The maximum time (in seconds) to wait when testing the initial RDP connection to Windows.
            # - Corresponding error: "REMOTE DESKTOP PROTOCOL FAILURE" (exit status 14).
            # DEFAULT VALUE: '30'
            RDP_TIMEOUT="30"

            # APPLICATION SCAN
            # - The maximum time (in seconds) to wait for the script that scans for installed applications on Windows to complete.
            # - Corresponding error: "APPLICATION QUERY FAILURE" (exit status 15).
            # DEFAULT VALUE: '60'
            APP_SCAN_TIMEOUT="60"

            # WINDOWS BOOT
            # - The maximum time (in seconds) to wait for the Windows VM to boot if it is not running, before attempting to launch an application.
            # DEFAULT VALUE: '120'
            BOOT_TIMEOUT="120"

            # FREERDP RAIL HIDEF
            # - This option controls the value of the `hidef` option passed to the /app parameter of the FreeRDP command.
            # - Setting this option to 'off' may resolve window misalignment issues related to maximized windows.
            # DEFAULT VALUE: 'on'
            HIDEF="on"
        '' else "Winapps is not activated in the nix configuration";

        # use winapps location even if not activated for simplicity
        home.file.".config/winapps/compose.yaml".text = ''
            # For documentation, FAQ, additional configuration options and technical help, visit: https://github.com/dockur/windows

            name: "windows"
            volumes:
                data:
                    driver_opts:
                        type: none
                        o: bind
                        device: ${config.my.home.services.windows.disk-location}

            services:
                windows:
                    image: ghcr.io/dockur/windows:latest
                    container_name: Windows # Created Docker VM Name.
                    environment:
                        VERSION: "11"
                        RAM_SIZE: "8G" # RAM allocated to the Windows VM.
                        CPU_CORES: "4" # CPU cores allocated to the Windows VM.
                        DISK_SIZE: "96G" # Size of the primary hard disk.
                        # DISK2_SIZE: "32G" # Uncomment to add an additional hard disk to the Windows VM. Ensure it is mounted as a volume below.
                        USERNAME: "${config.my.home.services.windows.username}" 
                        PASSWORD: "${config.my.home.services.windows.password}" 
                        LANGUAGE: English
                        REGION: "fr-FR"
                        KEYBOARD: "fr-FR"
                        HOME: "''\${HOME}" # Set path to Linux user home folder.
                        #GPU: "Y" # Active l'installation des modules GPU dans le conteneur
                        #KVM: "Y"
                        #ARGUMENTS: "-device virtio-vga-gl,xres=1920,yres=1080 -display egl-headless,gl=on"
                    ports:
                        - 8006:8006 # Map '8006' on Linux host to '8006' on Windows VM --> For VNC Web Interface @ http://127.0.0.1:8006.
                        - 3389:3389/tcp # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
                        - 3389:3389/udp # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
                    cap_add:
                        - NET_ADMIN  # Add network permission
                    stop_grace_period: 120s # Wait 120 seconds before sending SIGTERM when attempting to shut down the Windows VM.
                    restart: on-failure # Restart the Windows VM if the exit code indicates an error.
                    volumes:
                        - data:/storage # Mount volume 'data' to use as Windows 'C:' drive.
                        - ''\${HOME}:/shared # Mount Linux user home directory @ '\\host.lan\Data'.
                        - /run/opengl-driver:/host-opengl-driver:ro # Crucial pour NixOS
                        - ./oem:/oem # Enables automatic post-install execution of 'oem/install.bat', applying Windows registry modifications contained within 'oem/RDPApps.reg'.
                    devices:
                        - /dev/kvm # Enable KVM.
                        - /dev/net/tun # Enable tuntap
                        - /dev/dri:/dev/dri # Passes GPU
                        - /dev/kfd
                    security_opt:
                        - seccomp=unconfined
                    #group_add:
                    #    - "303" #`getent group render` pour trouver le groupe de render
                    #deploy:
                    #    resources:
                    #        reservations:
                    #            devices:
                    #                - capabilities: [gpu]
                    #                count: 1 # alternatively, use `count: all` for all GPUs

        '';
    };
}



