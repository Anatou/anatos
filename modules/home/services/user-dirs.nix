{ lib, config, pkgs, ...}:

{
    options.my.home.services.user-dirs.enable = lib.mkEnableOption "Enable default apps configuration";

    options.my.home.services.user-dirs.documents = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the documents folder";
    };

    options.my.home.services.user-dirs.download = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the download folder";
    };

    options.my.home.services.user-dirs.desktop = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the desktop folder";
    };

    options.my.home.services.user-dirs.music = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the music folder";
    };

    options.my.home.services.user-dirs.pictures = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the pictures folder";
    };

    options.my.home.services.user-dirs.templates = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the templates folder";
    };

    options.my.home.services.user-dirs.videos = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the videos folder";
    };

    options.my.home.services.user-dirs.publicShare = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Name for the publicShare folder";
    };

    


    config = lib.mkIf config.my.home.services.user-dirs.enable {
        xdg.userDirs = lib.mkMerge [
            {enable = true; createDirectories = true;}

            (lib.mkIf (config.my.home.services.user-dirs.documents != "") {
                documents = config.my.home.services.user-dirs.documents;
            })
            (lib.mkIf (config.my.home.services.user-dirs.documents == "") {
                documents = null;
            })

            (lib.mkIf (config.my.home.services.user-dirs.download != "") {
                download = config.my.home.services.user-dirs.download;
            })
            (lib.mkIf (config.my.home.services.user-dirs.download == "") {
                download = null;
            })

            (lib.mkIf (config.my.home.services.user-dirs.desktop != "") {
                desktop = config.my.home.services.user-dirs.desktop;
            })
            (lib.mkIf (config.my.home.services.user-dirs.desktop == "") {
                desktop = null;
            })

            (lib.mkIf (config.my.home.services.user-dirs.music != "") {
                music = config.my.home.services.user-dirs.music;
            })
            (lib.mkIf (config.my.home.services.user-dirs.music == "") {
                music = null;
            })

            (lib.mkIf (config.my.home.services.user-dirs.pictures != "") {
                pictures = config.my.home.services.user-dirs.pictures;
            })
            (lib.mkIf (config.my.home.services.user-dirs.pictures == "") {
                pictures = null;
            })

            (lib.mkIf (config.my.home.services.user-dirs.templates != "") {
                templates = config.my.home.services.user-dirs.templates;
            })
            (lib.mkIf (config.my.home.services.user-dirs.templates == "") {
                templates = null;
            })

            (lib.mkIf (config.my.home.services.user-dirs.videos != "") {
                videos = config.my.home.services.user-dirs.videos;
            })
            (lib.mkIf (config.my.home.services.user-dirs.videos == "") {
                videos = null;
            })

            (lib.mkIf (config.my.home.services.user-dirs.publicShare != "") {
                publicShare = config.my.home.services.user-dirs.publicShare;
            })
            (lib.mkIf (config.my.home.services.user-dirs.publicShare == "") {
                publicShare = null;
            })
        ];
    };
}