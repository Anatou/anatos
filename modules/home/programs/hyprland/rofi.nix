{ lib, config, pkgs, ...}:

{
    config = lib.mkIf config.my.home.programs.hyprland.enable {
        home.packages = with pkgs; [
        ];

        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            extraConfig = {
                modi = "drun,filebrowser,run";
                show-icons = true;
                icon-theme = "Papirus";
                font = "FiraCode 11";
                drun-display-format = "{icon} {name}";
                display-drun = "Apps 🔎";
                display-run = "Run";
                display-filebrowser = "File";
                window-format = "{w} · {c} · {t}";
            };
            theme =
            let 
                inherit (config.lib.formats.rasi) mkLiteral;
            in lib.mkForce {
                "*" = {
                    background=     mkLiteral "#000000ff";
                    background-alt= mkLiteral "#303030ff";
                    foreground=     mkLiteral "#FFFFFFFF";
                    selected=       mkLiteral "#61AFEFFF";
                    active=         mkLiteral "#98C379FF";
                    urgent=         mkLiteral "#E06C75FF";
                    border-colour=               mkLiteral "var(selected)";
                    handle-colour=               mkLiteral "var(foreground)";
                    background-colour=           mkLiteral "var(background)";
                    foreground-colour=           mkLiteral "var(foreground)";
                    alternate-background=        mkLiteral "var(background-alt)";
                    normal-background=           mkLiteral "var(background)";
                    normal-foreground=           mkLiteral "var(foreground)";
                    urgent-background=           mkLiteral "var(urgent)";
                    urgent-foreground=           mkLiteral "var(background)";
                    active-background=           mkLiteral "var(active)";
                    active-foreground=           mkLiteral "var(background)";
                    selected-normal-background=  mkLiteral "var(selected)";
                    selected-normal-foreground=  mkLiteral "var(background)";
                    selected-urgent-background=  mkLiteral "var(active)";
                    selected-urgent-foreground=  mkLiteral "var(background)";
                    selected-active-background=  mkLiteral "var(urgent)";
                    selected-active-foreground=  mkLiteral "var(background)";
                    alternate-normal-background= mkLiteral "var(background)";
                    alternate-normal-foreground= mkLiteral "var(foreground)";
                    alternate-urgent-background= mkLiteral "var(urgent)";
                    alternate-urgent-foreground= mkLiteral "var(background)";
                    alternate-active-background= mkLiteral "var(active)";
                    alternate-active-foreground= mkLiteral "var(background)";
                };

                "window" = {
                    /* properties for window widget */
                    transparency=     "real";
                    location=         mkLiteral "center";
                    anchor=           mkLiteral "center";
                    fullscreen=       false;
                    width=            mkLiteral "800px";
                    height=           mkLiteral "50%";
                    x-offset=         mkLiteral "0px";
                    y-offset=         mkLiteral "0px";

                    /* properties for all widgets */
                    enabled=          true;
                    margin=           mkLiteral "0px";
                    padding=          mkLiteral "0px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "10px";
                    border-color=     mkLiteral "@border-colour";
                    cursor=           "default";
                    background-color= mkLiteral "@background-colour";
                };

                /*****----- Main Box -----*****/
                "mainbox" = {
                    enabled=          true;
                    spacing=          mkLiteral "20px";
                    margin=           mkLiteral "0px";
                    padding=          mkLiteral "20px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "0px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "transparent";
                    children=         map mkLiteral [ "inputbar" "message" "listview" "mode-switcher" ];
                };

                /*****----- Inputbar -----*****/
                "inputbar" = {
                    enabled=          true;
                    spacing=          mkLiteral "10px";
                    margin=           mkLiteral "0px";
                    padding=          mkLiteral "8px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "4px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "@alternate-background";
                    text-color=       mkLiteral "@foreground-colour";
                    children=         map mkLiteral [ "prompt" "entry" ];
                };

                "prompt" = {
                    enabled=          true;
                    background-color= mkLiteral "inherit";
                    text-color=       mkLiteral "inherit";
                };
                "textbox-prompt-colon" = {
                    enabled=          true;
                    expand=           false;
                    str=              "::";
                    background-color= mkLiteral "inherit";
                    text-color=       mkLiteral "inherit";
                };
                "entry" = {
                    enabled=           true;
                    background-color=  mkLiteral "inherit";
                    text-color=        mkLiteral "inherit";
                    cursor=            mkLiteral "text";
                    placeholder=       "search...";
                    placeholder-color= mkLiteral "inherit";
                };
                "num-filtered-rows" = {
                    enabled=          true;
                    expand=           false;
                    background-color= mkLiteral "inherit";
                    text-color=       mkLiteral "inherit";
                };
                "textbox-num-sep" = {
                    enabled=          true;
                    expand=           false;
                    str=              "/";
                    background-color= mkLiteral "inherit";
                    text-color=       mkLiteral "inherit";
                };
                "num-rows"=  {
                    enabled=          true;
                    expand=           false;
                    background-color= mkLiteral "inherit";
                    text-color=       mkLiteral "inherit";
                };
                "case-indicator" = {
                    enabled=          true;
                    background-color= mkLiteral "inherit";
                    text-color=       mkLiteral "inherit";
                };

                /*****----- Listview -----*****/
                "listview" = {
                    enabled=       true;
                    columns=       1;
                    lines=         10;
                    cycle=         true;
                    dynamic=       true;
                    scrollbar=     false;
                    layout=        mkLiteral "vertical";
                    reverse=       false;
                    fixed-height=  true;
                    fixed-columns= true;
                    
                    spacing=          mkLiteral "2px";
                    margin=           mkLiteral "0px";
                    padding=          mkLiteral "0px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "0px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "transparent";
                    text-color=       mkLiteral "@foreground-colour";
                    cursor=           "default";
                };
                "scrollbar" = {
                    handle-width=     mkLiteral "5px";
                    handle-color=     mkLiteral "@handle-colour";
                    border-radius=    mkLiteral "8px";
                    background-color= mkLiteral "@alternate-background";
                };

                /*****----- Elements -----*****/
                "element" = {
                    enabled=          true;
                    spacing=          mkLiteral "4px";
                    margin=           mkLiteral "0px";
                    padding=          mkLiteral "4px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "4px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "transparent";
                    text-color=       mkLiteral "@foreground-colour";
                    cursor=           "pointer";
                };
                "element normal.normal" = {
                    background-color= mkLiteral "var(normal-background)";
                    text-color=       mkLiteral "var(normal-foreground)";
                };
                "element normal.urgent" = {
                    background-color= mkLiteral "var(urgent-background)";
                    text-color=       mkLiteral "var(urgent-foreground)";
                };
                "element normal.active" = {
                    background-color= mkLiteral "var(active-background)";
                    text-color=       mkLiteral "var(active-foreground)";
                };
                "element selected.normal" = {
                    background-color= mkLiteral "var(normal-foreground)";
                    text-color=       mkLiteral "var(normal-background)";
                };
                "element selected.urgent" = {
                    background-color= mkLiteral "var(selected-urgent-background)";
                    text-color=       mkLiteral "var(selected-urgent-foreground)";
                };
                "element selected.active" = {
                    background-color= mkLiteral "var(selected-active-background)";
                    text-color=       mkLiteral "var(selected-active-foreground)";
                };
                "element alternate.normal" = {
                    background-color= mkLiteral "var(alternate-normal-background)";
                    text-color=       mkLiteral "var(alternate-normal-foreground)";
                };
                "element alternate.urgent" = {
                    background-color= mkLiteral "var(alternate-urgent-background)";
                    text-color=       mkLiteral "var(alternate-urgent-foreground)";
                };
                "element alternate.active" = {
                    background-color= mkLiteral "var(alternate-active-background)";
                    text-color=       mkLiteral "var(alternate-active-foreground)";
                };
                "element-icon" = {
                    background-color= mkLiteral "transparent";
                    text-color=       mkLiteral "inherit";
                    size=             mkLiteral "16px";
                    cursor=           mkLiteral "inherit";
                };
                "element-text" = {
                    background-color= mkLiteral "transparent";
                    text-color=       mkLiteral "inherit";
                    highlight=        mkLiteral "inherit";
                    cursor=           mkLiteral "inherit";
                    vertical-align=   mkLiteral "0.5";
                    horizontal-align= mkLiteral "0.0";
                };

                /*****----- Mode Switcher -----*****/
                "mode-switcher" = {
                    enabled=          true;
                    spacing=          mkLiteral "8px";
                    margin=           mkLiteral "0px";
                    padding=          mkLiteral "0px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "4px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "@alternate-background";
                    text-color=       mkLiteral "@foreground-colour";
                };
                "button" = {
                    padding=          mkLiteral "8px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "4px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "transparent";
                    text-color=       mkLiteral "inherit";
                    cursor=           "pointer";
                };
                "button selected" = {
                    background-color= mkLiteral "var(normal-foreground)";
                    text-color=       mkLiteral "var(normal-background)";
                };

                /*****----- Message -----*****/
                "message" = {
                    enabled=          true;
                    margin=           mkLiteral "0px";
                    padding=          mkLiteral "0px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "0px 0px 0px 0px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "transparent";
                    text-color=       mkLiteral "@foreground-colour";
                };
                "textbox" = {
                    padding=           mkLiteral "8px";
                    border=            mkLiteral "0px solid";
                    border-radius=     mkLiteral "4px";
                    border-color=      mkLiteral "@border-colour";
                    background-color=  mkLiteral "@alternate-background";
                    text-color=        mkLiteral "@foreground-colour";
                    vertical-align=    mkLiteral "0.5";
                    horizontal-align=  mkLiteral "0.0";
                    highlight=         mkLiteral "none";
                    placeholder-color= mkLiteral "@foreground-colour";
                    blink=             true;
                    markup=            true;
                };
                "error-message" = {
                    padding=          mkLiteral "10px";
                    border=           mkLiteral "0px solid";
                    border-radius=    mkLiteral "0px";
                    border-color=     mkLiteral "@border-colour";
                    background-color= mkLiteral "@background-colour";
                    text-color=       mkLiteral "@foreground-colour";
                };
            };
        };
    };
}