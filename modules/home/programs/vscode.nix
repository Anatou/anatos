{ lib, config, ...}:

{
    options.my.home.programs.vscode.enable = lib.mkEnableOption "Enable my vscode configuration";

    config = lib.mkIf config.my.home.programs.vscode.enable {
        programs.vscode = {
            enable = true;
            profiles = {
                default = {
                    extensions = with pkgs.vscode-extensions; [
                        pinage404.nix-extension-pack
                        peterschmalfeldt.explorer-exclude
                        ms-vscode.cpptools-extension-pack
                        ms-python.python
                        ms-python.debugpy
                        ms-python.vscode-pylance
                        vscodevim.vim
                        tamasfe.even-better-toml
                        shd101wyy.markdown-preview-enhanced
                        mads-hartmann.bash-ide-vscode
                        zainchen.json
                    ];
                    userSettings = {
                        "editor.detectIndentation" = false;
                        "editor.tabSize" = 4;
                        "[nix]"."editor.tabSize" = 4;
                        "editor.indentSize" = "tabSize";
                        "files.autoSave" = "onFocusChange";
                    };
                };
            };
        };
    };
}