{
    description = "A function creating a devshell with zsh";

    outputs = { self, pkgs, system }:
    {
        mkZshDevShell = { name, packages ? [], env ? {}, beforeZsh ? "", afterZsh ? "" }: pkgs.mkShell {
            name = "${name}";
            packages = packages;
            env = {
                SH = "zsh";
                DEVSHELL = name;
            } // env;
            shellHook = beforeZsh + ''
                exec $SH
            '' + afterZsh;
            # If a other .zshrc is sourced, it must contain
            # source ~/.zshrc
            # RPROMPT=$RPROMPT"%F{red}["$DEVSHELL"]%f"
            # And the shellHook must contain
            # export ZDOTDIR="$HOME/anatos/modules/devshells" #important, does not work from env
        };
    };
}