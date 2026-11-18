{ pkgs }:
name: zshrc: pkgs.symlinkJoin {
    name = "${name}-zdotdir";
    paths = [
        (pkgs.writeTextDir ".zshenv" ''
            _devshell_zdotdir="$ZDOTDIR"
            [[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
            # ZDOTDIR choisi par home-manager (ou $HOME s'il n'en définit pas)
            if [[ "$ZDOTDIR" == "$_devshell_zdotdir" ]]; then
                export DEVSHELL_REAL_ZDOTDIR="$HOME"
            else
                export DEVSHELL_REAL_ZDOTDIR="$ZDOTDIR"
            fi
            # on remet le nôtre pour que zsh lise notre .zshrc
            export ZDOTDIR="$_devshell_zdotdir"
            unset _devshell_zdotdir
        '')
        (pkgs.writeTextDir ".zshrc" ''
            export ZDOTDIR="$DEVSHELL_REAL_ZDOTDIR"
            [[ -f "$ZDOTDIR/.zshrc" ]] && source "$ZDOTDIR/.zshrc"
            ${zshrc}
        '')
    ];
}