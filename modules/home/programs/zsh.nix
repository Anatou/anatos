{...}:
{
    options.programs.zsh.enable = lib.mkEnableOption "Enable zsh";

    config = lib.mkIf config.programs.zsh.enable {
        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
        };
    }
}