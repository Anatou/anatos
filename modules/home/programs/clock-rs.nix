{ lib, config, ...}:

{
    options.my.home.programs.clock.enable = lib.mkEnableOption "Enable my clock-rs configuration";

    config = lib.mkIf config.my.home.programs.clock.enable {
        programs.clock-rs = {
            enable = true;

            settings = {
                general = {
                    color = "bright-red";
                    interval = 250;
                    blink = false;
                    bold = true;
                };

                position = {
                    horizontal = "center";
                    vertical = "center";
                };

                date = {
                    fmt = "%A, %B %d %Y";
                    use_12h = false;
                    utc = false;
                    hide_seconds = false;
                };
            };
        };

        home.shellAliases = {
            stopwatch = "clock-rs stopwatch";
            timer = "clock-rs timer";
            clock = "clock-rs -s clock";
        };
    };
}