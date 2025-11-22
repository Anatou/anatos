{ lib, config, ...}:
{
    options.my.home.programs.zsh.enable = lib.mkEnableOption "Enable my zsh configuration";

    config = lib.mkIf config.my.home.programs.zsh.enable {
        programs.zsh = {
            enable = true;
            autocd = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            initContent = ''
                if [ -z "$DEVSHELL" ]; then fastfetch && echo "\nCoucou bebou ^-^ Je t'aime ! "; fi
                bindkey "^H" backward-kill-word
                bindkey "^[^?" backward-kill-word
            '';
            localVariables = {
                PROMPT = "%(?..%F{9}× )%f%2~ %(!.#.>) ";
            };
        };
    };
}