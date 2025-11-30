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
                    "video/h264" = config.my.home.services.default-apps.text;
                })
                (lib.mkIf (config.my.home.services.default-apps.code != []) {
                    "text/*" = config.my.home.services.default-apps.code;
                    "text/basic" = config.my.home.services.default-apps.code;
                    "text/calendar" = config.my.home.services.default-apps.code;
                    "text/css" = config.my.home.services.default-apps.code;
                    "text/csv" = config.my.home.services.default-apps.code;
                    "text/javascript" = config.my.home.services.default-apps.code;
                    "text/json" = config.my.home.services.default-apps.code;
                    "text/jsx" = config.my.home.services.default-apps.code;
                    "text/mathml" = config.my.home.services.default-apps.code;
                    "text/richtext" = config.my.home.services.default-apps.code;
                    "text/rust" = config.my.home.services.default-apps.code;
                    "text/uri-list" = config.my.home.services.default-apps.code;
                    "text/x-asm" = config.my.home.services.default-apps.code;
                    "text/x-c" = config.my.home.services.default-apps.code;
                    "text/x-fortran" = config.my.home.services.default-apps.code;
                    "text/x-java-source" = config.my.home.services.default-apps.code;
                    "text/x-pascal" = config.my.home.services.default-apps.code;
                    "text/x-python" = config.my.home.services.default-apps.code;
                    "text/x-setext" = config.my.home.services.default-apps.code;
                    "text/zig" = config.my.home.services.default-apps.code;
                })
                (lib.mkIf (config.my.home.services.default-apps.video != []) {
                    "video/*" = config.my.home.services.default-apps.video;
                    "video/mp4" = config.my.home.services.default-apps.video;
                    "video/mpeg" = config.my.home.services.default-apps.video;
                    "video/quicktime" = config.my.home.services.default-apps.video;
                    "video/webm" = config.my.home.services.default-apps.video;
                    "video/x-msvideo" = config.my.home.services.default-apps.video;
                    "video/x-matroska" = config.my.home.services.default-apps.video;
                    "video/x-m4v" = config.my.home.services.default-apps.video;
                })
                (lib.mkIf (config.my.home.services.default-apps.image != []) {
                    "image/*" = config.my.home.services.default-apps.image;
                    "image/avif" = config.my.home.services.default-apps.image;
                    "image/avifs" = config.my.home.services.default-apps.image;
                    "image/bmp" = config.my.home.services.default-apps.image;
                    "image/jpeg" = config.my.home.services.default-apps.image;
                    "image/pjpeg" = config.my.home.services.default-apps.image;
                    "image/gif" = config.my.home.services.default-apps.image;
                    "image/png" = config.my.home.services.default-apps.image;
                    "image/webp" = config.my.home.services.default-apps.image;
                })
                (lib.mkIf (config.my.home.services.default-apps.audio != []) {
                    "audio/*" = config.my.home.services.default-apps.audio;
                    "audio/mp4" = config.my.home.services.default-apps.audio;
                    "audio/mpeg" = config.my.home.services.default-apps.audio;
                    "audio/wav" = config.my.home.services.default-apps.audio;
                })
            ];
        };
    };
}