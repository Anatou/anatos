{ lib, config, ... }:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {
        wayland.windowManager.hyprland.settings = {

            "binds:hide_special_on_workspace_change" = true;

            bind = [
                "$modifier,Q,exec,kitty"
                "$modifier,A,exec,flatpak run app.zen_browser.zen"
                "$modifier,Space,exec,rofi -show drun"
                "$modifier,C,killactive"
                "$modifier,Z,exec,bash $HOME/.config/waybar/waybar-controler.sh"
                "$modifier SHIFT,Z,exec,bash $HOME/.config/waybar/waybar-controler.sh big"
                "$modifier CONTROL,Z,exec,bash $HOME/.config/waybar/waybar-controler.sh kill"
                "$modifier,X,exec,code"
                "$modifier SHIFT,X,exec,code ~/anatos"
                "$modifier,M,exit"
                "$modifier,E,exec,kitty -e yazi"
                "$modifier,O,exec,obsidian"
                "$modifier SHIFT,E,exec,thunar"
                "$modifier,F,fullscreen"
                "$modifier,P,pseudo"
                "$modifier,V,togglefloating"
                "$modifier,J,togglesplit"
                "$modifier,L,exec,loginctl lock-session"
                "$modifier,I,exec,exec,bash rofimoji"
                "$modifier,Print,exec,wayland-screenshot"
                
                "$modifier,S,togglespecialworkspace,special" 
                "$modifier,D,togglespecialworkspace,utils"
                "$modifier,twosuperior,workspace,1"
                "$modifier,ampersand,workspace,2"
                "$modifier,eacute,workspace,3"
                "$modifier,quotedbl,workspace,4"
                "$modifier,apostrophe,workspace,5"
                "$modifier,parenleft,workspace,6"
                "$modifier,minus,workspace,7"
                "$modifier,egrave,workspace,8"
                "$modifier,underscore,workspace,9"
                "$modifier,ccedilla,workspace,10"
                "$modifier SHIFT,S,movetoworkspace,special:special"
                "$modifier SHIFT,D,movetoworkspace,special:utils"
                "$modifier SHIFT,twosuperior,movetoworkspace,1"
                "$modifier SHIFT,ampersand,movetoworkspace,2"
                "$modifier SHIFT,eacute,movetoworkspace,3"
                "$modifier SHIFT,quotedbl,movetoworkspace,4"
                "$modifier SHIFT,apostrophe,movetoworkspace,5"
                "$modifier SHIFT,parenleft,movetoworkspace,6"
                "$modifier SHIFT,minus,movetoworkspace,7"
                "$modifier SHIFT,egrave,movetoworkspace,8"
                "$modifier SHIFT,underscore,movetoworkspace,9"
                "$modifier SHIFT,ccedilla,movetoworkspace,10"
                ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ",XF86AudioPlay, exec, playerctl play-pause"
                ",XF86AudioPause, exec, playerctl play-pause"
                ",XF86AudioNext, exec, playerctl next"
                ",XF86AudioPrev, exec, playerctl previous"
                ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
                ",XF86MonBrightnessUp,exec,brightnessctl set +5%"

            ];

            bindm = [
                "$modifier, mouse:272, movewindow"
                "$modifier CONTROL, mouse:272, resizewindow"
                "$modifier, mouse:273, resizewindow"
            ];
        };
    };
}
