{ lib, config, ... }:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {
        home.file.".config/hypr/movewindowright" = {
            text = ''hyprctl dispatch layoutmsg focus l; hyprctl dispatch layoutmsg cyclenext'';
            executable = true;
        };
        home.file.".config/hypr/movewindowleft" = {
            text = ''hyprctl dispatch layoutmsg focus r; hyprctl dispatch layoutmsg swapwithmaster ignoremaster'';
            executable = true;
        };
        home.file.".config/hypr/openrofi" = {
            text = ''pkill rofi || rofi -show drun'';
            executable = true;
        };
		home.file.".config/hypr/togglewidth" = {
            text = ''
				curr_mon=$(hyprctl activewindow -j | jq -r '.monitor')
				curr_width=$(hyprctl activewindow -j | jq -r '.size[0]')
				mon_width=$(hyprctl monitors -j | jq -r '.[] | select(.id == '$curr_mon') | .width')
				mon_scale=$(hyprctl monitors -j | jq -r '.[] | select(.id == '$curr_mon') | .scale')
				width_to_scale=$(echo "$curr_width * $mon_scale" | bc)
				half_mon_width=$(echo "$mon_width / 2" | bc)
				echo $half_mon_width
				if [[ $width_to_scale > $half_mon_width ]]; then
					hyprctl dispatch layoutmsg colresize 0.5
				else
					hyprctl dispatch layoutmsg colresize 1.0
				fi
			'';
            executable = true;
        };
        wayland.windowManager.hyprland.settings = {

            "binds:hide_special_on_workspace_change" = true;

            gesture = [
                "3,up, mod: $modifier, dispatcher, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
                "3,down, mod: $modifier, dispatcher, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
                "3,left, mod: $modifier, dispatcher, exec, brightnessctl set 10%-"
                "3,right, mod: $modifier, dispatcher, exec, brightnessctl set 10%+"

				"3,vertical, workspace"
				"3,down, mod: ALT, close"
				"3,up, mod: ALT, dispatcher, exec, $HOME/.config/hypr/openrofi"
				"3,horizontal, mod: ALT, cursorZoom, 2.0"
				
				"3,left,dispatcher,exec, $HOME/.config/hypr/movewindowleft"
                "3,right,dispatcher,exec, $HOME/.config/hypr/movewindowright"
                
                "4,down,fullscreen"
                "4,up,float"
            ];

            bind = [
                # Apps
                "$modifier,Q,exec,kitty"
                "$modifier,A,exec,flatpak run app.zen_browser.zen"
                "$modifier,Space,exec,$HOME/.config/hypr/openrofi"
                "$modifier,I,exec,rofimoji"
                "$modifier,C,killactive"
                "$modifier,Z,exec,bash $HOME/.config/waybar/waybar-controler.sh"
                "$modifier SHIFT,Z,exec,bash $HOME/.config/waybar/waybar-controler.sh big"
                "$modifier CONTROL,Z,exec,bash $HOME/.config/waybar/waybar-controler.sh kill"
                "$modifier,X,exec,code"
                "$modifier SHIFT,X,exec,code ~/anatos"
                "$modifier,E,exec,kitty -e yazi"
                "$modifier,O,exec,obsidian"
                "$modifier SHIFT,E,exec,thunar"
                "$modifier,F,fullscreen"
                "$modifier,P,pseudo"
                "$modifier,V,togglefloating"
                "$modifier SHIFT,V,pin"
                "$modifier,J,togglesplit"
                "$modifier,L,exec,loginctl lock-session"
                "$modifier,I,exec,exec,bash rofimoji"
                ",Print,exec,wayland-screenshot"

                # Master layout
                "$modifier,Left,layoutmsg,swapwithmaster ignoremaster" 
                "$modifier,Right,layoutmsg,cyclenext" 
                "$modifier SHIFT,Left,layoutmsg,cycleprev" 
                "$modifier SHIFT,Right,layoutmsg,cyclenext"

                # Scrolling layout
				"$modifier,Left, layoutmsg, focus l"
				"$modifier,Right, layoutmsg, focus r"
				"$modifier SHIFT,Left, layoutmsg, swapcol l"
				"$modifier SHIFT,Right, layoutmsg, swapcol r"

				"$modifier,D, exec, $HOME/.config/hypr/togglewidth"
				"$modifier,dead_circumflex, layoutmsg, colresize -0.15"
				"$modifier,dollar, layoutmsg, colresize +0.15"
				
                # Monitor
                "$modifier CTRL,Left, focusmonitor, l"
				"$modifier CTRL,Right, focusmonitor, r"

                # Workspace
				"$modifier,Up, workspace, -1"
				"$modifier,Down, workspace, +1"
                "$modifier,mouse_up, workspace, +1"
                "$modifier,mouse_down, workspace, -1"
                "$modifier SHIFT,Up, movetoworkspace, -1"
				"$modifier SHIFT,Down, movetoworkspace, +1"
                
                "$modifier,S,togglespecialworkspace,special" 
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

                # Function keys
                "CTRL ALT,Delete,exit"
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
