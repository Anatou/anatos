{ pkgs, lib, config, ... }:
let 
    meteofrance-daemon = pkgs.callPackage ./../../../mypkgs/meteofrance-daemon/release-0.1.0 { inherit pkgs; };
in
{
    options.my.home.services.meteofrance-daemon.enable = lib.mkEnableOption "Enable meteofrance-daemon";

    config = lib.mkIf config.my.home.services.meteofrance-daemon.enable {
        home.packages = [ meteofrance-daemon ];
    
        systemd.user.services.meteofrance-daemon = {
            Unit = {
                Description = "meteofrance-daemon";
            };
            Install = {
                WantedBy = [ "default.target" ];
            };
            Service = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = "${meteofrance-daemon}/bin/meteofrance-daemon start";
                ExecStop = "${meteofrance-daemon}/bin/meteofrance-daemon stop";
                ExecReload = "${meteofrance-daemon}/bin/meteofrance-daemon restart";
            };
        };
    };
}
