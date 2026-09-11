{ pkgs, lib, config, nixosConfig, ... }:
{

    options.my.home.programs.ollama.enable = lib.mkEnableOption "Enable ollama";

    config = lib.mkIf config.my.home.programs.ollama.enable {
        services.ollama = {
            enable = true;
            acceleration = "rocm";
            host = "127.0.0.1";
            port = 11434;

            environmentVariables = {
				OLLAMA_IGPU_ENABLE = "1";
	            # HSA_OVERRIDE_GFX_VERSION = "11.5.0";
            };
        };

        home.packages = [ pkgs.rocmPackages.rocminfo pkgs.clinfo ];

        # home.shellAliases = {
        #     ollarun = "kitty --detach sh -c 'ollama serve' && sleep 1 && ollama run";
        #     qwen = "kitty --detach sh -c 'ollama serve' && sleep 1 && ollama run qwen3:14b";
        #     codestral = "kitty --detach sh -c 'ollama serve' && sleep 1 && ollama run codestral:22b";
        # };
    };
}



