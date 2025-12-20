{ lib, config, pkgs, ...}:

{
    options.my.home.programs.caffeine.enable = lib.mkEnableOption "Enable my caffeine configuration";

    config = lib.mkIf config.my.home.programs.caffeine.enable {
        home.packages = with pkgs; [
            caffeine-ng
        ];

        systemd.user.services.caffeine = {
            Unit = {
                Description = "caffeine";
            };

            Install = {
                WantedBy = [ "graphical-session.target" ];
            };

            Service = {
                Restart = "on-failure";
                PrivateTmp = true;
                ProtectSystem = "full";
                Type = "exec";
                Slice = "session.slice";
                ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
            };
        };

    };
}