{
  description = "A flake containing many development shells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkZshDevShell = { devshellTitle, packages, env }: pkgs.mkShell {
        name = "${devshellTitle}";
        packages = packages;
        env = {
            SH = "zsh";
            DEVSHELL = devshellTitle;
        } // env;
        shellHook = ''
            #echo "Entering C development shell"
            exec $SH
        '';
        # If a other .zshrc is sourced, it must contain
        # source ~/.zshrc
        # RPROMPT=$RPROMPT"%F{red}["$DEVSHELL"]%f"
        # And the shellHook must contain
        # export ZDOTDIR="$HOME/anatos/modules/devshells" #important, does not work from env
      };
    in 
    {
    devShells.${system}.c = mkZshDevShell {
        devshellTitle = "c-devshell";
        packages = with pkgs; [
            libgcc
            cmake
            clang-tools
            gdb
        ];
        env = {};
    };
  };
}
