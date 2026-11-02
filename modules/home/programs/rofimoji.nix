{ lib, config, pkgs, ...}:

{
    options.my.home.programs.rofimoji.enable = lib.mkEnableOption "Enable my rofimoji configuration";

    config = lib.mkIf config.my.home.programs.rofimoji.enable {
        home.packages = with pkgs; [
            rofimoji
            (writeShellApplication {
                name = "rofimoji-cfg";
                runtimeInputs = [ rofimoji jq ];
                text = ''
                # app_id des applis où le mode "type" est cassé
                clipboard_apps=(obsidian Beeper)

                app_id=$(niri msg --json focused-window | jq -r '.app_id // empty')

                action="type"
                for a in "''${clipboard_apps[@]}"; do
                    if [ "$app_id" = "$a" ]; then action="clipboard"; fi
                done

                exec rofimoji -a "$action" -f emojis latin-1 math
                '';
            })
        ];
        # All extension files are @${pkgs.rofimoji}/lib/python3.12/site-packages/picker/data/
    };
}