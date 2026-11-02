{ pkgs, lib, config, nixosConfig, ... }:
{

    options.my.home.programs.ollama.enable = lib.mkEnableOption "Enable ollama";

    config = lib.mkIf config.my.home.programs.ollama.enable {
        services.ollama = {
            enable = true;
			# ==== ROCm
            acceleration = "rocm";
			# ==== Vulkan
			#acceleration = null;
  			#package = pkgs.ollama-vulkan;
            host = "127.0.0.1";
            port = 11434;

            environmentVariables = {
				OLLAMA_CONTEXT_LENGTH = "32768"; # 32k context

				OLLAMA_IGPU_ENABLE = "1";		# enable iGPU
				# ==== ROCm
				# ==== Vulkan
				#HIP_VISIBLE_DEVICES = "-1";     # Disable ROCm
				#OLLAMA_VULKAN = "1";			# Enable Vulkan
				#GGML_VK_VISIBLE_DEVICES = "0";  # Select first GPU/iGPU


                LLAMA_ARG_DIO = "1";				# Use Direct-I/O to load model
				LLAMA_ARG_SPEC_TYPE = "draft-mtp";	# Use Multi-Token-Prediction
  				LLAMA_ARG_SPEC_DRAFT_N_MAX = "3";	# Max 3 token for MTP
                #OLLAMA_FLASH_ATTENTION = "1"; # activeate KV
                #OLLAMA_KV_CACHE_TYPE = "q8_0"; # reduces cache size
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



