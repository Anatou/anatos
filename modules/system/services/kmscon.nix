{ lib, config, pkgs, ...}:

{
    options.my.system.services.kmscon.enable = lib.mkEnableOption "Enable and configure kmscon tty font features";

    config = lib.mkIf config.my.system.services.kmscon.enable {
		# Does not work
        services.kmscon = {
            enable = true;
            hwRender = true;            # rendu accéléré GPU (mets false si ça bug)
            useXkbConfig = true;        # reprend ta disposition clavier X11
            fonts = [
                # police latine en premier, puis police CJK en repli
                { name = "JetBrainsMono Nerd Font"; package = pkgs.nerd-fonts.jetbrains-mono; }
                { name = "Noto Sans Mono CJK JP";   package = pkgs.noto-fonts-cjk-sans; }
            ];
            extraConfig = ''
                font-size=20
            '';
        };

    };
}