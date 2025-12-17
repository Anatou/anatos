{ lib, config, ...}:

{
    options.my.home.programs.neovim.enable = lib.mkEnableOption "Enable my neovim configuration";

    config = lib.mkIf config.my.home.programs.neovim.enable {
        programs.nvf = {
            enable = true;

            settings.vim = {
                lsp.enable = true;
                vimAlias = true;
                viAlias = true;
                withNodeJs = true;
                lineNumberMode = "relNumber";
                enableLuaLoader = true;
                preventJunkFiles = true;
                options = {
                    tabstop = 4;
                    shiftwidth = 2;
                    wrap = false;
                };

                clipboard = {
                    enable = true;
                    registers = "unnamedplus";
                    providers = {
                        wl-copy.enable = true;
                        xsel.enable = true;
                    };
                };

                telescope.enable = true;

                spellcheck = {
                    enable = true;
                    languages = [ "en" "fr" ];
                    programmingWordlist.enable = true;
                };

                 lsp = {
                    formatOnSave = true;
                    lspkind.enable = false;
                    lightbulb.enable = false;
                    lspsaga.enable = false;
                    trouble.enable = true;
                    lspSignature.enable = true;
                    otter-nvim.enable = false;
                    nvim-docs-view.enable = false;
                };

                languages = {
                    enableFormat = true;
                    enableTreesitter = true;
                    enableExtraDiagnostics = true;
                    nix.enable = true;
                    clang.enable = true;
                    zig.enable = true;
                    python.enable = true;
                    markdown.enable = true;
                    ts = {
                        enable = true;
                        lsp.enable = true;
                        format.type = ["prettierd"];
                        extensions.ts-error-translator.enable = true;
                    };
                    html.enable = true;
                    lua.enable = true;
                    css = {
                        enable = true;
                        format.type = ["prettierd"];
                    };
                    typst.enable = true;
                    rust = {
                        enable = true;
                        extensions.crates-nvim.enable = true;
                    };
                };
                visuals = {
                    nvim-web-devicons.enable = true;
                    nvim-cursorline.enable = true;
                    cinnamon-nvim.enable = true;
                    fidget-nvim.enable = true;
                    highlight-undo.enable = true;
                    indent-blankline.enable = true;
                    rainbow-delimiters.enable = true;
                };

                autopairs.nvim-autopairs.enable = true;
                autocomplete.nvim-cmp.enable = true;
                snippets.luasnip.enable = true;
                tabline.nvimBufferline.enable = true;
                treesitter.context.enable = false;
                binds = {
                    whichKey.enable = true;
                    cheatsheet.enable = true;
                };
                git = {
                    enable = true;
                    gitsigns.enable = true;
                    gitsigns.codeActions.enable = false;
                };
                projects.project-nvim.enable = true;
                dashboard.dashboard-nvim.enable = true;
                filetree.neo-tree.enable = true;
                notify = {
                    nvim-notify.enable = true;
                    nvim-notify.setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
                };

                ui = {
                    borders.enable = true;
                    noice.enable = true;
                    colorizer.enable = true;
                    illuminate.enable = true;
                    breadcrumbs = {
                        enable = false;
                        navbuddy.enable = false;
                    };
                    smartcolumn = {
                        enable = true;
                    };
                    fastaction.enable = true;
                };

                session = {
                    nvim-session-manager.enable = false;
                };
                comments = {
                    comment-nvim.enable = true;
                };


            };
        };
    };
}