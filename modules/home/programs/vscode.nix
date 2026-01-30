{ lib, config, pkgs, ...}:

{
    options.my.home.programs.vscode.enable = lib.mkEnableOption "Enable my vscode configuration";

    config = lib.mkIf config.my.home.programs.vscode.enable {
        nixpkgs.config.allowUnfree = true;

        programs.vscode = {
            enable = true;
            package = pkgs.vscode.fhs;
            profiles = {
                default = {
                    enableUpdateCheck = false;
                    enableExtensionUpdateCheck = false;

                    extensions = with pkgs.vscode-extensions; [
                        ms-vscode.cpptools-extension-pack
                        ms-python.python
                        ms-python.debugpy
                        ms-python.vscode-pylance
                        tamasfe.even-better-toml
                        shd101wyy.markdown-preview-enhanced
                        mads-hartmann.bash-ide-vscode
                        zainchen.json
                        jnoortheen.nix-ide
                        reditorsupport.r
                    ];
                    userSettings = {
                        "editor.detectIndentation" = false;
                        "editor.tabSize" = 4;
                        "[nix]"."editor.tabSize" = 4;
                        "editor.indentSize" = "tabSize";
                        "files.autoSave" = "onFocusChange";
                        "editor.fontFamily" = lib.mkDefault "'Fira Code', 'monospace', 'monospace'";
                        "editor.fontLigatures" = true;
                        "keyboard.dispatch" = "keycode";
                    };
                };
            };
        };
    };
}