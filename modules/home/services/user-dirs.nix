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

    


    config = lib.mkIf config.my.home.services.user-dirs.enable {
        xdg.userDirs = lib.mkMerge [
            {enable = true; createDirectories = true;}

            lib.mkIf (config.my.home.services.user-dirs.documents != "") {
                config.my.home.services.user-dirs.documents
            }
            lib.mkIf (config.my.home.services.user-dirs.download != "") {
                config.my.home.services.user-dirs.download
            }
            lib.mkIf (config.my.home.services.user-dirs.desktop != "") {
                config.my.home.services.user-dirs.desktop
            }
            lib.mkIf (config.my.home.services.user-dirs.music != "") {
                config.my.home.services.user-dirs.music
            }
            lib.mkIf (config.my.home.services.user-dirs.pictures != "") {
                config.my.home.services.user-dirs.pictures
            }
            lib.mkIf (config.my.home.services.user-dirs.templates != "") {
                config.my.home.services.user-dirs.templates
            }
            lib.mkIf (config.my.home.services.user-dirs.videos != "") {
                config.my.home.services.user-dirs.videos
            }
        ];
    };
}