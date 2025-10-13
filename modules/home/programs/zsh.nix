{ lib, config, ...}:
{
    options.my.zsh.enable = lib.mkEnableOption "Enable zsh";

    config = lib.mkIf config.my.zsh.enable {
        programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            initContent = "echo 'Welcome to zsh !'";
            shellAliases = {
                c = "clear";
                gs = "git status";
            };
        };
    };
}