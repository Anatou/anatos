{ lib, config, pkgs, ...}:

{
    options.my.system.programs.server-programs.enable = lib.mkEnableOption "Installs useful system programs";

    config = lib.mkIf config.my.system.programs.server-programs.enable {
        environment.systemPackages = with pkgs; [
            bash
            vim 
            wget
            git
            htop
            unrar
            unzip
            killall
            jq
        ];
    };
}