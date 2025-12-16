let
    no-children = { "_no-children" = true; };
in
{
binds = {
    "Mod+A" = { 
        _props = { hotkey-overlay-title = "Open a Web Browser: Zen"; };
        spawn-sh = "flatpak run app.zen_browser.zen";
    };
    "Mod+E" = { 
        _props = { hotkey-overlay-title = "Open a File Explorer: yazi"; };
        spawn-sh = "kitty -e yazi";
    };
    "Mod+Alt+H" = { 
        _props = { hotkey-overlay-title = "Open help"; };
        show-hotkey-overlay = no-children;
    };
    "Mod+Q" = {   
        _props = { hotkey-overlay-title = "Open a Terminal: kitty"; };
        spawn = "kitty";
    };
    "Mod+Space" = {   
        _props = { hotkey-overlay-title = "Run an Application: rofi"; };
        spawn-sh = "rofi -show drun";
    };
    "Mod+Z" = {
        _props = { hotkey-overlay-title = "Activate Waybar"; };
        spawn-sh = "bash $HOME/.config/waybar/waybar-controler.sh";
    };
    "Mod+Shift+Z" = {
        _props = { hotkey-overlay-title = "Activate Waybar"; };
        spawn-sh = "bash $HOME/.config/waybar/waybar-controler.sh big";
    };
    "Mod+Ctrl+Z" = {
        _props = { hotkey-overlay-title = "Activate Waybar"; };
        spawn-sh = "bash $HOME/.config/waybar/waybar-controler.sh kill";
    };
    "XF86AudioRaiseVolume" = {   
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
    };
    "XF86AudioLowerVolume" = {   
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
    };
    "XF86AudioMute" = {   
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    };
    "XF86AudioMicMute" = {   
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    };
    "XF86MonBrightnessUp" = { 
        _props = { allow-when-locked = true; };
        spawn-sh = "brightnessctl --class=backlight set +10%";
    };
    "XF86MonBrightnessDown" = { 
        _props = { allow-when-locked = true; };
        spawn-sh = "brightnessctl --class=backlight set 10%-";
    };

    "Mod+W" = { _props = { repeat = false; }; toggle-overview = no-children; };
    "Mod+C" = { _props = { repeat = false; }; close-window = no-children; };

    #"Mod+D" = { maximize-window-to-edges = no-children; };

    "Mod+Left" = {  focus-column-left = no-children; };
    "Mod+Down" = {  focus-window-or-workspace-down = no-children; };
    "Mod+Up" =   {  focus-window-or-workspace-up = no-children; };
    "Mod+Right" = { focus-column-right = no-children; };
    "Mod+H" = {     focus-column-left = no-children; };
    "Mod+J" = {     focus-window-or-workspace-down = no-children; };
    "Mod+K" = {     focus-window-or-workspace-up = no-children; };
    "Mod+L" = {     focus-column-right = no-children; };

    "Mod+Ctrl+Left" = {  move-column-left = no-children; };
    "Mod+Ctrl+Down" = {  move-window-down = no-children; };
    "Mod+Ctrl+Up" = {    move-window-up = no-children; };
    "Mod+Ctrl+Right" = { move-column-right = no-children; };
    "Mod+Ctrl+H" = {     move-column-left = no-children; };
    "Mod+Ctrl+J" = {     move-window-down = no-children; };
    "Mod+Ctrl+K" = {     move-window-up = no-children; };
    "Mod+Ctrl+L" = {     move-column-right = no-children; };

    "Mod+Twosuperior" = { focus-column-first = no-children; };
    "Mod+Home" = { focus-column-first = no-children; };
    "Mod+End" = {  focus-column-last = no-children; };
    "Mod+Ctrl+Home" = { move-column-to-first = no-children; };
    "Mod+Ctrl+End" = {  move-column-to-last = no-children; };

    "Mod+Shift+Left" = {  focus-monitor-left = no-children; };
    "Mod+Shift+Down" = {  focus-monitor-down = no-children; };
    "Mod+Shift+Up" = {    focus-monitor-up = no-children; };
    "Mod+Shift+Right" = { focus-monitor-right = no-children; };
    "Mod+Shift+H" = {     focus-monitor-left = no-children; };
    "Mod+Shift+J" = {     focus-monitor-down = no-children; };
    "Mod+Shift+K" = {     focus-monitor-up = no-children; };
    "Mod+Shift+L" = {     focus-monitor-right = no-children; };

    "Mod+Shift+Ctrl+Left" = {  move-column-to-monitor-left = no-children; };
    "Mod+Shift+Ctrl+Down" = {  move-column-to-monitor-down = no-children; };
    "Mod+Shift+Ctrl+Up" = {    move-column-to-monitor-up = no-children; };
    "Mod+Shift+Ctrl+Right" = { move-column-to-monitor-right = no-children; };
    "Mod+Shift+Ctrl+H" = {     move-column-to-monitor-left = no-children; };
    "Mod+Shift+Ctrl+J" = {     move-column-to-monitor-down = no-children; };
    "Mod+Shift+Ctrl+K" = {     move-column-to-monitor-up = no-children; };
    "Mod+Shift+Ctrl+L" = {     move-column-to-monitor-right = no-children; };

    "Mod+Page_Down" = { focus-workspace-down = no-children; };
    "Mod+Page_Up" = {   focus-workspace-up = no-children; };
    "Mod+U" = {         focus-workspace-down = no-children; };
    "Mod+I" = {         focus-workspace-up = no-children; };

    "Mod+Ctrl+Page_Down" = { move-column-to-workspace-down = no-children; };
    "Mod+Ctrl+Page_Up" = {   move-column-to-workspace-up = no-children; };
    "Mod+Ctrl+U" = {         move-column-to-workspace-down = no-children; };
    "Mod+Ctrl+I" = {         move-column-to-workspace-up = no-children; };

    "Mod+Shift+Page_Down" = { move-workspace-down = no-children; };
    "Mod+Shift+Page_Up" = {   move-workspace-up = no-children; };
    "Mod+Shift+U" = {         move-workspace-down = no-children; };
    "Mod+Shift+I" = {         move-workspace-up = no-children; };

    "Mod+WheelScrollDown" = {      _props = { cooldown-ms = 150; }; focus-workspace-down = no-children; };
    "Mod+WheelScrollUp" = {        _props = { cooldown-ms = 150; }; focus-workspace-up = no-children; };
    "Mod+Ctrl+WheelScrollDown" = { _props = { cooldown-ms = 150; }; move-column-to-workspace-down = no-children; };
    "Mod+Ctrl+WheelScrollUp" = {   _props = { cooldown-ms = 150; }; move-column-to-workspace-up = no-children; };

    "Mod+WheelScrollRight" = {      focus-column-right = no-children; };
    "Mod+WheelScrollLeft" = {       focus-column-left = no-children; };
    "Mod+Ctrl+WheelScrollRight" = { move-column-right = no-children; };
    "Mod+Ctrl+WheelScrollLeft" = {  move-column-left = no-children; };

    "Mod+Shift+WheelScrollDown" = {      focus-column-right = no-children; };
    "Mod+Shift+WheelScrollUp" = {        focus-column-left = no-children; };
    "Mod+Ctrl+Shift+WheelScrollDown" = { move-column-right = no-children; };
    "Mod+Ctrl+Shift+WheelScrollUp" = {   move-column-left = no-children; };

    "Mod+ampersand" = { focus-workspace = 1; };
    "Mod+eacute"    = { focus-workspace = 2; };
    "Mod+quotedbl"  = { focus-workspace = 3; };
    "Mod+4" = { focus-workspace = 4; };
    "Mod+5" = { focus-workspace = 5; };
    "Mod+6" = { focus-workspace = 6; };
    "Mod+7" = { focus-workspace = 7; };
    "Mod+8" = { focus-workspace = 8; };
    "Mod+9" = { focus-workspace = 9; };

    "Mod+Ctrl+ampersand" = { move-column-to-workspace = 1; };
    "Mod+Ctrl+eacute"    = { move-column-to-workspace = 2; };
    "Mod+Ctrl+quotedbl"  = { move-column-to-workspace = 3; };
    "Mod+Ctrl+4" = { move-column-to-workspace = 4; };
    "Mod+Ctrl+5" = { move-column-to-workspace = 5; };
    "Mod+Ctrl+6" = { move-column-to-workspace = 6; };
    "Mod+Ctrl+7" = { move-column-to-workspace = 7; };
    "Mod+Ctrl+8" = { move-column-to-workspace = 8; };
    "Mod+Ctrl+9" = { move-column-to-workspace = 9; };

    "Mod+O" = {  consume-or-expel-window-left = no-children; };
    "Mod+P" = { consume-or-expel-window-right = no-children; };

    "Mod+Comma" = {  consume-window-into-column = no-children; };
    "Mod+Semicolon" = { expel-window-from-column = no-children; };

    "Mod+R" = {       switch-preset-column-width = no-children; };
    "Mod+Shift+R" = { switch-preset-window-height = no-children; };
    "Mod+Ctrl+R" = {  reset-window-height = no-children; };
    "Mod+F" = {       maximize-column = no-children; };
    "Mod+Shift+F" = { fullscreen-window = no-children; };

    "Mod+Ctrl+F" = { expand-column-to-available-width = no-children; };

    "Mod+X" = {       center-column = no-children; };
    "Mod+Ctrl+X" = {  center-visible-columns = no-children; };

    "Mod+Minus" = { set-column-width = "-10%" ; };
    "Mod+Equal" = { set-column-width = "+10%" ; };

    "Mod+Shift+Minus" = { set-window-height = "-10%" ; };
    "Mod+Shift+Equal" = { set-window-height = "+10%" ; };

    "Mod+V" = {       toggle-window-floating = no-children; };
    "Mod+Shift+V" = { switch-focus-between-floating-and-tiling = no-children; };

    "Mod+Alt+J" = { toggle-column-tabbed-display = no-children; };

    "Print" = {        screenshot = no-children; };
    "Ctrl+Print" = {   screenshot-screen = no-children; };
    "Alt+Print" = {    screenshot-window = no-children; };
    "Mod+Escape" = { _props = {allow-inhibiting = false; }; toggle-keyboard-shortcuts-inhibit = no-children; };

    "Mod+Shift+E" = { quit = no-children; };
    "Ctrl+Alt+Delete" = { quit = no-children; };
    "Mod+Shift+Alt+L" = { power-off-monitors = no-children; };
  };
}