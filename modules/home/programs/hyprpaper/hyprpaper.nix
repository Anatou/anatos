{ host, config, pkgs, lib, username, ...}:
let 
    theme = config.my.home.programs.hyprpaper.theme;
    jpg_bg = [ "modane-montagne" "anatole-thabor" "hyprpaper" "mountain_sunset" ];
    png_bg = [ ];
    backgrounds = jpg_bg ++ png_bg;
    
    file_extension = 
        if builtins.any (el: el==theme) jpg_bg then
            "jpg"
        else if builtins.any (el: el==theme) png_bg then
            "png" 
        else "";
in
{
    # !!!!!!!!!!!!!!
    # hyprpaper has some troubles starting on its own
    # You must execute the following line after startup of your DE
    # `systemctl --user restart hyprpaper.service`

    options.my.home.programs.hyprpaper.enable = lib.mkEnableOption "Enable my hyprpaper configuration";
    options.my.home.programs.hyprpaper.theme = lib.mkOption {
        type = lib.types.enum (backgrounds);
        default = "mountain_sunset";
        description = "Choose your hyprpaper background (${backgrounds})";
    };

    config = lib.mkIf config.my.home.programs.hyprpaper.enable {

    services.hyprpaper = {
        enable = true;
        settings = {
            preload = [ "/home/${username}/anatos/modules/home/programs/hyprpaper/${theme}.${file_extension}" ];
            wallpaper = [ ",/home/${username}/anatos/modules/home/programs/hyprpaper/${theme}.${file_extension}" ];
        };
    };
    home.file."hyprpaper_test".text = ''
            /home/${username}/anatos/modules/home/programs/hyprpaper/${theme}.${file_extension}
        '';
};
}