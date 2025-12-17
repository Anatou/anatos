{ lib, config, pkgs, ...}:

{
    options.my.home.programs.yazi.enable = lib.mkEnableOption "Enable my yazi configuration";

    config = lib.mkIf config.my.home.programs.yazi.enable {
        programs.yazi = {
            enable = true;
            enableBashIntegration = true;
            enableFishIntegration = true;
            enableZshIntegration = true;
            shellWrapperName = "yy";

            plugins = {
                lazygit = pkgs.yaziPlugins.lazygit;
                full-border = pkgs.yaziPlugins.full-border;
                git = pkgs.yaziPlugins.git;
                smart-enter = pkgs.yaziPlugins.smart-enter;
            };

            settings = {
                manager = {
                    ratio = [ 1 3 4];
                };
            };

            keymap = {
                mgr.prepend_keymap = [
                    {
                        on = [ "g" "h" ];
                        run = "cd ~";
                        desc = "Go home";
                    }
                    {
                        on = [ "g" "c" ];
                        run = "cd ~/.config";
                        desc = "Goto ~/.config";
                    }
                    {
                        on = [ "g" "d" ];
                        run = "cd ~/download";
                        desc = "Goto ~/download";
                    }
                    {
                        on = [ "g" "t" ];
                        run = "cd ~/documents";
                        desc = "Goto ~/documents";
                    }
                    {
                        on = [ "g" "u" ];
                        run = "cd /run/media/anatou";
                        desc = "Goto mounted devices";
                    }
                    {
                        on = [ "g" "a" ];
                        run = "cd ~/anatos";
                        desc = "Goto ~/anatos";
                    }
                    {
                        on = [ "g" "i" ];
                        run = "cd ~/documents/insa-4if";
                        desc = "Goto ~/documents/insa-4if";
                    }
                    {
                        on = "<Enter>";
                        run = "plugin smart-enter";
                        desc = "Enter the child directory, or open the file";
                    }
                    {
                        on = "<C-Enter>";
                        run = ["enter" "shell -- code ." "leave"];
                        desc = "Open vscode in the current directory";
                    }
                ];
            };
        };
    };
}