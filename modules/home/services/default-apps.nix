{ lib, config, pkgs, ...}:

{
    options.my.home.services.default-apps.enable = lib.mkEnableOption "Enable default apps configuration";

    options.my.home.services.default-apps.pdf = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for pdf files (must be a .desktop)";
    };

    options.my.home.services.default-apps.url = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for url links (must be a .desktop)";
    };

    options.my.home.services.default-apps.text = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for text files (must be a .desktop)";
    };

    options.my.home.services.default-apps.code = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for text files about code (must be a .desktop)";
    };

    options.my.home.services.default-apps.video = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for video files (must be a .desktop)";
    };

    options.my.home.services.default-apps.image = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for image files (must be a .desktop)";
    };

    options.my.home.services.default-apps.audio = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Choose which app is default for audio files (must be a .desktop)";
    };




    config = lib.mkIf config.my.home.services.default-apps.enable {
        xdg.mimeApps = {
            enable = true;
            defaultApplications = lib.mkMerge [
                (lib.mkIf (config.my.home.services.default-apps.url != []) {
                    "text/html" = config.my.home.services.default-apps.url;
                    "x-scheme-handler/http" = config.my.home.services.default-apps.url;
                    "x-scheme-handler/https" = config.my.home.services.default-apps.url;
                    "x-scheme-handler/about" = config.my.home.services.default-apps.url;
                    "x-scheme-handler/unknown" = config.my.home.services.default-apps.url;
                })
                (lib.mkIf (config.my.home.services.default-apps.pdf != []) {
                    "application/pdf" = config.my.home.services.default-apps.pdf;
                })
                (lib.mkIf (config.my.home.services.default-apps.text != []) {
                    "text/plain" = config.my.home.services.default-apps.text;
                    "text/markdown" = config.my.home.services.default-apps.text;
                })
                (lib.mkIf (config.my.home.services.default-apps.code != []) {
                    "text/*" = config.my.home.services.default-apps.code;
                })
                (lib.mkIf (config.my.home.services.default-apps.video != []) {
                    "video/*" = config.my.home.services.default-apps.video;
                })
                (lib.mkIf (config.my.home.services.default-apps.image != []) {
                    "image/*" = config.my.home.services.default-apps.image;
                    "image/png" = config.my.home.services.default-apps.image;
                })
                (lib.mkIf (config.my.home.services.default-apps.audio != []) {
                    "audio/*" = config.my.home.services.default-apps.audio;
                })
            ];
        };
    };
}