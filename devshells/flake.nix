{
    description = "A flake containing many development shells";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    };

    outputs = { self, nixpkgs, ... }@inputs:
    let
        systems = [ "x86_64-linux" ];

        forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
            let pkgs = nixpkgs.legacyPackages.${system};
            in f pkgs system
        );

        importShell = shells: builtins.listToAttrs (
            map (pair: {
                name  = pair.value.prefix + ":" + pair.name;
                value = pair.value;
            }) (nixpkgs.lib.attrsets.attrsToList shells)
        );

        shellFiles = nixpkgs.lib.attrNames (
            nixpkgs.lib.filterAttrs 
                (name: type: type == "regular" && nixpkgs.lib.hasSuffix ".nix" name) 
                (builtins.readDir ./shells)
        );
    in {

        ####################################################################
        # 🔧 Load all shells
        ####################################################################
        # allShells.<system> = { c = {...}; python = {...}; ... }
        allShells = forAllSystems (pkgs: system:
            nixpkgs.lib.foldl' (acc: file: 
                let imported = import (./shells + "/${file}") { inherit pkgs system; };
                in  acc // importShell imported
            ) {} shellFiles
        );


        ####################################################################
        # 👨🏻‍💻 Expose devshells
        ####################################################################
        devShells = forAllSystems (pkgs: system:
            let shells = self.allShells.${system};
            in nixpkgs.lib.mapAttrs (_: shell: shell.function shell) shells
        );


        ####################################################################
        # 📦 Protect packages
        ####################################################################
        packages = forAllSystems (pkgs: system:
        let
            shells = self.allShells.${system};

            # On extrait tous les paquets exactement comme avant
            allPkgs = nixpkgs.lib.flatten (map
                (sh: sh.packages)
                (nixpkgs.lib.attrValues shells)
            ) ++ import ./lib/libs.nix { inherit pkgs; };

        in {
            # On expose un seul paquet global qui regroupe tout.
            # buildEnv crée un environnement virtuel contenant tous les "paths" fournis.
            cache-all-shells = pkgs.buildEnv { 
                name = "all-devshells-cache"; 
                paths = allPkgs; 
                # On ignore les collisions (si deux shells utilisent la même dépendance)
                ignoreCollisions = true; 
            };
        });
    };
}