{ host, config, pkgs, lib, ...}:

{
config = lib.mkIf config.my.home.programs.hyprland.enable {

    services.hypridle = {
        enable = true;
            settings = {
                general = {
                    #after_sleep_cmd = "hyprctl dispatch dpms on";
                    #ignore_dbus_inhibit = false;
                    before_sleep_cmd = "loginctl lock-session";
                    lock_cmd = "hyprlock";
                };
                listener = [
                    {
                        timeout = 3000; # 5 minutes
                        on-timeout = "hyprlock";
                    }
                ];
            };
        };
    };
}