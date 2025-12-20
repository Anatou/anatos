let
    no-children = { "_no-children" = true; };
in
{
binds = {
    "Mod+A" = {  _props = { hotkey-overlay-title = "Open a Web Browser: Zen"; }; spawn-sh = "flatpak run app.zen_browser.zen"; };
    "Mod+Q" = {  _props = { hotkey-overlay-title = "Open a Terminal: kitty"; }; spawn = "kitty"; };
    "Mod+O" = {  _props = { hotkey-overlay-title = "Open Obsidian"; }; spawn = "obsidian"; };
    "Mod+E" = {  _props = { hotkey-overlay-title = "Open a File Explorer: yazi"; }; spawn-sh = "kitty -e yazi"; };
    "Mod+Shift+E" = {  _props = { hotkey-overlay-title = "Open a File Explorer: thunar"; }; spawn = "thunar"; };
    "Mod+H" = {  _props = { hotkey-overlay-title = "Open help"; }; show-hotkey-overlay = no-children; };
    "Mod+Space" = {  _props = { hotkey-overlay-title = "Run an Application: rofi"; }; spawn-sh = "rofi -show drun"; };
    "Mod+Shift+X" = {  _props = { hotkey-overlay-title = "Launch vscode and Open anatos"; }; spawn-sh = "code ~/anatos"; };
    "Mod+I" = {  _props = { hotkey-overlay-title = "Run an emoji picker: rofimoji"; }; spawn-sh = "rofimoji"; };
    "Mod+Tab" = {  _props = { hotkey-overlay-title = "Switch to media workspace"; }; spawn-sh = "niri-media-switcher"; };

    "Mod+Shift+W" = { center-column = no-children; };
    "Mod+W" = { _props = { repeat = false; }; toggle-overview = no-children; };
    "Mod+C" = { _props = { repeat = false; }; close-window = no-children; };
    "Ctrl+Alt+Delete" = { quit = no-children; };
    "Mod+Escape" = { _props = {allow-inhibiting = false; }; toggle-keyboard-shortcuts-inhibit = no-children; };
    
    "Mod+Z" = { _props = { hotkey-overlay-title = "Activate Waybar"; }; spawn-sh = "$HOME/.config/waybar/waybar-controler.sh"; };
    "Mod+Shift+Z" = { _props = { hotkey-overlay-title = "Activate Waybar"; }; spawn-sh = "$HOME/.config/waybar/waybar-controler.sh big"; };
    "Mod+Ctrl+Z" = { _props = { hotkey-overlay-title = "Activate Waybar"; }; spawn-sh = "$HOME/.config/waybar/waybar-controler.sh kill"; };

    "Print" = {      screenshot = no-children; };
    "Ctrl+Print" = { screenshot-screen = no-children; };
    "Alt+Print" = {  screenshot-window = no-children; };

    "Mod+F" = { fullscreen-window = no-children; };
    "Mod+Shift+F" = { toggle-windowed-fullscreen = no-children; };
    "Mod+Ctrl+F" = { toggle-windowed-fullscreen = no-children; };
    #"Mod+F" = [ { maximize-column = no-children; } { maximize-row = no-children; } ];
    "Mod+D" = { maximize-column = no-children; };
    "Mod+Shift+D" = { expand-column-to-available-width = no-children; };

    "Mod+V" = {       toggle-window-floating = no-children; };
    "Mod+Shift+V" = { switch-focus-between-floating-and-tiling = no-children; };

    "Mod+J" =           { toggle-column-tabbed-display = no-children; };
    "Mod+Shift+J"     = { consume-window-into-column = no-children; };
    "Mod+Shift+Alt+J" = { expel-window-from-column = no-children; };

    "Mod+Shift+Alt+L" = { power-off-monitors = no-children; };
    "Mod+L" = { spawn-sh = "loginctl lock-session"; };

    "XF86AudioRaiseVolume" = { 
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"; };
    "XF86AudioLowerVolume" = { 
        _props = { allow-when-locked = true; };
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; };
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
    "Mod+TouchpadScrollDown" = { spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+"; };
    "Mod+TouchpadScrollUp"   = { spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-"; };




    "Mod+Left" = {  focus-column-left = no-children; };
    "Mod+Down" = {  focus-window-or-workspace-down = no-children; };
    "Mod+Up" =   {  focus-window-or-workspace-up = no-children; };
    "Mod+Right" = { focus-column-right = no-children; };
    #"Mod+H" = {     focus-column-left = no-children; };
    #"Mod+J" = {     focus-window-or-workspace-down = no-children; };
    #"Mod+K" = {     focus-window-or-workspace-up = no-children; };
    #"Mod+L" = {     focus-column-right = no-children; };

    "Mod+Shift+Alt+Left" = {  move-column-left = no-children; };
    "Mod+Shift+Alt+Right" = { move-column-right = no-children; };
    "Mod+Shift+Left" = {  consume-or-expel-window-left = no-children; };
    "Mod+Shift+Right" = { consume-or-expel-window-right = no-children; };
    "Mod+Shift+Down" = {  move-window-down = no-children; };
    "Mod+Shift+Up" = {    move-window-up = no-children; };
    #"Mod+Ctrl+H" = {     move-column-left = no-children; };
    #"Mod+Ctrl+J" = {     move-window-down = no-children; };
    #"Mod+Ctrl+K" = {     move-window-up = no-children; };
    #"Mod+Ctrl+L" = {     move-column-right = no-children; };

    "Mod+Twosuperior" = { focus-column-first = no-children; };
    "Mod+Home" = { focus-column-first = no-children; };
    "Mod+End" = {  focus-column-last = no-children; };
    "Mod+Shift+Twosuperior" = { move-column-to-first = no-children; };
    "Mod+Shift+Home" = { move-column-to-first = no-children; };
    "Mod+Shift+End" = {  move-column-to-last = no-children; };

    "Mod+Ctrl+Left" = {  focus-monitor-left = no-children; };
    "Mod+Ctrl+Down" = {  focus-monitor-down = no-children; };
    "Mod+Ctrl+Up" = {    focus-monitor-up = no-children; };
    "Mod+Ctrl+Right" = { focus-monitor-right = no-children; };
    #"Mod+Shift+H" = {     focus-monitor-left = no-children; };
    #"Mod+Shift+J" = {     focus-monitor-down = no-children; };
    #"Mod+Shift+K" = {     focus-monitor-up = no-children; };
    #"Mod+Shift+L" = {     focus-monitor-right = no-children; };

    "Mod+Shift+Ctrl+Left" = {  move-column-to-monitor-left = no-children; };
    "Mod+Shift+Ctrl+Down" = {  move-column-to-monitor-down = no-children; };
    "Mod+Shift+Ctrl+Up" = {    move-column-to-monitor-up = no-children; };
    "Mod+Shift+Ctrl+Right" = { move-column-to-monitor-right = no-children; };
    #"Mod+Shift+Ctrl+H" = {     move-column-to-monitor-left = no-children; };
    #"Mod+Shift+Ctrl+J" = {     move-column-to-monitor-down = no-children; };
    #"Mod+Shift+Ctrl+K" = {     move-column-to-monitor-up = no-children; };
    #"Mod+Shift+Ctrl+L" = {     move-column-to-monitor-right = no-children; };

    "Mod+Page_Down" = { focus-workspace-down = no-children; };
    "Mod+Page_Up" = {   focus-workspace-up = no-children; };
    #"Mod+U" = {         focus-workspace-down = no-children; };
    #"Mod+I" = {         focus-workspace-up = no-children; };

    "Mod+Ctrl+Page_Down" = { move-column-to-workspace-down = no-children; };
    "Mod+Ctrl+Page_Up" = {   move-column-to-workspace-up = no-children; };
    #"Mod+Ctrl+U" = {         move-column-to-workspace-down = no-children; };
    #"Mod+Ctrl+I" = {         move-column-to-workspace-up = no-children; };

    "Mod+Shift+Page_Down" = { move-workspace-down = no-children; };
    "Mod+Shift+Page_Up" = {   move-workspace-up = no-children; };
    #"Mod+Shift+U" = {         move-workspace-down = no-children; };
    #"Mod+Shift+I" = {         move-workspace-up = no-children; };

    "Mod+WheelScrollDown" = {      _props = { cooldown-ms = 150; }; focus-workspace-down = no-children; };
    "Mod+WheelScrollUp" = {        _props = { cooldown-ms = 150; }; focus-workspace-up = no-children; };
    #"Mod+Ctrl+WheelScrollDown" = { _props = { cooldown-ms = 150; }; move-column-to-workspace-down = no-children; };
    #"Mod+Ctrl+WheelScrollUp" = {   _props = { cooldown-ms = 150; }; move-column-to-workspace-up = no-children; };

    "Mod+WheelScrollRight" = {      focus-column-right = no-children; };
    "Mod+WheelScrollLeft" = {       focus-column-left = no-children; };
    #"Mod+Ctrl+WheelScrollRight" = { move-column-right = no-children; };
    #"Mod+Ctrl+WheelScrollLeft" = {  move-column-left = no-children; };

    "Mod+Shift+WheelScrollDown" = {  _props = { cooldown-ms = 150; }; focus-column-right = no-children; };
    "Mod+Shift+WheelScrollUp" = {    _props = { cooldown-ms = 150; }; focus-column-left = no-children; };
    #"Mod+Ctrl+Shift+WheelScrollDown" = { move-column-right = no-children; };
    #"Mod+Ctrl+Shift+WheelScrollUp" = {   move-column-left = no-children; };

    #"Mod+ampersand" = { focus-workspace = 1; };
    #"Mod+eacute"    = { focus-workspace = 2; };
    #"Mod+quotedbl"  = { focus-workspace = 3; };
    #"Mod+apostrophe" = { focus-workspace = 4; };
    #"Mod+parenleft" = { focus-workspace = 5; };
    #"Mod+minus" = { focus-workspace = 6; };
    #"Mod+egrave" = { focus-workspace = 7; };
    #"Mod+underscore" = { focus-workspace = 8; };
    #"Mod+ccedilla" = { focus-workspace = 9; };

    #"Mod+Ctrl+ampersand" = { move-column-to-workspace = 1; };
    #"Mod+Ctrl+eacute"    = { move-column-to-workspace = 2; };
    #"Mod+Ctrl+quotedbl"  = { move-column-to-workspace = 3; };
    #"Mod+Ctrl+apostrophe" = { move-column-to-workspace = 4; };
    #"Mod+Ctrl+parenleft" = { move-column-to-workspace = 5; };
    #"Mod+Ctrl+minus" = { move-column-to-workspace = 6; };
    #"Mod+Ctrl+egrave" = { move-column-to-workspace = 7; };
    #"Mod+Ctrl+underscore" = { move-column-to-workspace = 8; };
    #"Mod+Ctrl+ccedilla" = { move-column-to-workspace = 9; };

    "Mod+Y" = {  consume-or-expel-window-left = no-children; };
    "Mod+U" = { consume-or-expel-window-right = no-children; };


    "Mod+R" = {       switch-preset-column-width = no-children; };
    "Mod+Shift+R" = { switch-preset-window-height = no-children; };
    "Mod+Ctrl+R" = {  reset-window-height = no-children; };

    #"Mod+X" = {       center-column = no-children; };
    #"Mod+Ctrl+X" = {  center-visible-columns = no-children; };

    "Mod+Dead_circumflex" = { set-column-width = "-15%" ; };
    "Mod+Dollar" = { set-column-width = "+15%" ; };
    "Mod+Shift+Dead_circumflex" = { set-window-height = "-15%" ; };
    "Mod+Shift+Dollar" = { set-window-height = "+15%" ; };
  };
}