{ lib, config, username, ...}:

{
    options.my.system.services.auto-mount-data-drive.enable = lib.mkEnableOption "Enable systemd service to auto-mount the data partition";

    config = lib.mkIf config.my.system.services.auto-mount-data-drive.enable {
        systemd.services.auto-mount-data-drive = {
            enable = true;
            script = ''
                mount /dev/nvme0n1p3 /home/${username}/Document
            '';
            wantedBy = [ "multi-user.target" ];
        };
    };
}