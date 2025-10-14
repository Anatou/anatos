{ ... }:

{
    wayland.windowManager.hyprland.settings = {
        bind = [
            "$modifier,Q,exec,kitty"
            "$modifier,A,exec,firefox"
            "$modifier,C,forcekillactive"
            "$modifier,X,exec,hyprctl notify 1 1000 'rgb(ffffff)' 'Test'"
            "$modifier,M,exit"
        ];

        bindm = [
            "$modifier, mouse:272, movewindow"
            "$modifier SHIFT, mouse:272, resizewindow"
            "$modifier, mouse:273, resizewindow"
        ];
    };
}