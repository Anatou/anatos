{ pkgs, lib, config, nixosConfig, ... }:
{

    options.my.home.programs.ollama.enable = lib.mkEnableOption "Enable ollama";

    config = lib.mkIf config.my.home.programs.ollama.enable {
        home.packages = [
            pkgs.ollama
        ];
        home.shellAliases = {
            ollarun = "kitty --detach sh -c 'ollama serve' && sleep 1 && ollama run";
        };
    };
}



