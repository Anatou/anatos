{ lib, config, pkgs, ...}:

{
    options.my.home.services.cursor = lib.mkOption {
        type = lib.types.enum [ "none" "banana" "bibata" ];
        default = "none";
        description = "Choose your display manager (banana, bibata, none)";
    };

    config = lib.mkMerge [ 
        (lib.mkIf (config.my.home.services.cursor == "banana") {
        home.pointerCursor = {
                enable = true;
                hyprcursor.enable = true;
                x11.enable = true;
                sway.enable = true;
                gtk.enable = true;
                package = pkgs.banana-cursor;
                name = "Banana Cursor";
            };
        })

        (lib.mkIf (config.my.home.services.cursor == "bibata") {
        home.pointerCursor = {
                enable = true;
                hyprcursor.enable = true;
                x11.enable = true;
                sway.enable = true;
                gtk.enable = true;
                package = pkgs.bibata-cursors;
                name = "Bibata-Modern-Ice";
            };
        })
    ];
}