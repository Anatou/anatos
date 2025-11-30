{ lib, config, pkgs, ...}:

{
    options.my.home.programs.vscode.enable = lib.mkEnableOption "Enable my vscode configuration";

    config = lib.mkIf config.my.home.programs.vscode.enable {
        nixpkgs.config.allowUnfree = true;

        programs.vscode = {
            enable = true;
            profiles = {
                default = {
                    extensions = with pkgs.vscode-extensions; [
                        #pinage404.nix-extension-pack
                        #peterschmalfeldt.explorer-exclude
                        bbenoist.nix
                        ms-vscode.cpptools-extension-pack
                        ms-python.python
                        ms-python.debugpy
                        ms-python.vscode-pylance
                        ms-toolsai.jupyter
                        tamasfe.even-better-toml
                        shd101wyy.markdown-preview-enhanced
                        mads-hartmann.bash-ide-vscode
                        zainchen.json
                        jnoortheen.nix-ide
                    ];
                    userSettings = {
                        "editor.detectIndentation" = false;
                        "editor.tabSize" = 4;
                        "[nix]"."editor.tabSize" = 4;
                        "editor.indentSize" = "tabSize";
                        "files.autoSave" = "onFocusChange";
                        "editor.fontFamily" = lib.mkDefault "'Fira Code', 'monospace', 'monospace'";
                        "editor.fontLigatures" = true;
                    };
                };
            };
        };
    };
}