{ lib, config, pkgs, ...}:

{
    options.my.system.services.at.enable = lib.mkEnableOption "Enable at";

    config = lib.mkIf config.my.system.services.at.enable {
        services.atd.enable = true;
        environment.systemPackages = with pkgs; [
            at
            (pkgs.writeShellScriptBin "alarm" ''
            ALERT=$1
            shift 1
            echo "notify-send --urgency=critical ALERT \"$ALERT\"" | at "$@"
            '')
            (pkgs.writeShellScriptBin "alarms" ''
            echo -e "\x1b[1mAll future alarms:\x1b[0m"
            atq
            '')
            (pkgs.writeShellScriptBin "alert" ''
            notify-send --urgency=critical ALERT "$*"
            '')
        ];
    };
}

