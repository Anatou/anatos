{ ... }:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {
        wayland.windowManager.hyprland.settings = {
            bind = [
                "$modifier,Q,exec,kitty"
                "$modifier,A,exec,firefox"
                "$modifier,Space,exec,rofi-launcher"
                "$modifier,C,forcekillactive"
                "$modifier,X,exec,hyprctl notify 1 1000 'rgb(ffffff)' 'Test'"
                "$modifier,M,exit"
                "$modifier,P,pseudo"
                "$modifier,V,togglefloating"

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
                "$modifier SHIFT,S,movetoworkspace,special"
                "$modifier,S,togglespecialworkspace"
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
            ];

            bindm = [
                "$modifier, mouse:272, movewindow"
                "$modifier SHIFT, mouse:272, resizewindow"
                "$modifier, mouse:273, resizewindow"
            ];
        };
    };
}
