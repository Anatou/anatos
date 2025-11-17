{ lib, config, pkgs, ...}:

{
    options.my.home.services.mimeapps.enable = lib.mkEnableOption "Enable default apps configuration";

    options.my.home.services.mimeapps.pdf = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for pdf files (must be a .desktop)";
    };

    options.my.home.services.mimeapps.url = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for url links (must be a .desktop)";
    };

    options.my.home.services.mimeapps.text = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for text files (must be a .desktop)";
    };

    options.my.home.services.mimeapps.code = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for text files about code (must be a .desktop)";
    };

    options.my.home.services.mimeapps.video = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for video files (must be a .desktop)";
    };

    options.my.home.services.mimeapps.image = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for image files (must be a .desktop)";
    };

    options.my.home.services.mimeapps.audio = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for audio files (must be a .desktop)";
    };




    config = lib.mkIf config.my.home.services.mimeapps.enable {
        xdg.mimeApps = {
            enable = true;
            defaultApplications = lib.mkMerge [
                (lib.mkIf (config.my.home.services.mimeapps.url != []) {
                    "text/html" = config.my.home.services.mimeapps.url;
                    "x-scheme-handler/http" = config.my.home.services.mimeapps.url;
                    "x-scheme-handler/https" = config.my.home.services.mimeapps.url;
                    "x-scheme-handler/about" = config.my.home.services.mimeapps.url;
                    "x-scheme-handler/unknown" = config.my.home.services.mimeapps.url;
                })
                (lib.mkIf (config.my.home.services.mimeapps.pdf != []) {
                    "application/pdf" = config.my.home.services.mimeapps.pdf;
                })
                (lib.mkIf (config.my.home.services.mimeapps.text != []) {
                    "text/plain" = config.my.home.services.mimeapps.text;
                    "text/markdown" = config.my.home.services.mimeapps.text;
                })
                (lib.mkIf (config.my.home.services.mimeapps.code != []) {
                    "text/*" = config.my.home.services.mimeapps.code;
                })
                (lib.mkIf (config.my.home.services.mimeapps.video != []) {
                    "video/*" = config.my.home.services.mimeapps.video;
                })
                (lib.mkIf (config.my.home.services.mimeapps.image != []) {
                    "image/*" = config.my.home.services.mimeapps.image;
                })
                (lib.mkIf (config.my.home.services.mimeapps.audio != []) {
                    "audio/*" = config.my.home.services.mimeapps.audio;
                })
            ];
        };
    };
}