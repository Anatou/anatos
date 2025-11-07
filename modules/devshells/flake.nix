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
        packages = packages;
        shellHook = ''
            #echo "Entering C development shell"
            export ZDOTDIR="$HOME/anatos/modules/devshells" #important, does not work from env
            exec $SH
        '';
        env = {
            SH = "zsh";
            DEVSHELL = devshellTitle;
        } // env;
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
