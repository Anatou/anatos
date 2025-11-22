{ lib, config, username, ...}:

{
    options.my.system.services.auto-mount-data-drive.enable = lib.mkEnableOption "Enable systemd service to auto-mount the data partition";

    config = lib.mkIf config.my.system.services.auto-mount-data-drive.enable {
        #systemd.services.auto-mount-data-drive = {
        #    enable = true;
        #    script = ''
        #        mount /dev/nvme0n1p3 /home/${username}/Document >> /home/${username}/logs
        #    '';
        #    wantedBy = [ "multi-user.target" ];
        #};

        fileSystems."/home/${username}/documents" = {
            device = "/dev/nvme0n1p3";
            fsType = "ext4"; 
            options = [ "defaults" ];
        };

        # Makes the directory if does not exist
        systemd.tmpfiles.rules = [
            "d /home/${username}/documents 0755 ${username} users -"
        ];
    };
}