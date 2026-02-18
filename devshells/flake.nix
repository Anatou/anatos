{
    description = "A flake containing many development shells";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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

    in {

        ####################################################################
        # 🔧 Load all shells
        ####################################################################
        # allShells.<system> = { c = {...}; python = {...}; ... }
        allShells = forAllSystems (pkgs: system:
            importShell (import ./shells/c.nix      { inherit pkgs system; }) //
            importShell (import ./shells/java.nix { inherit pkgs system; })   //
            importShell (import ./shells/node.nix { inherit pkgs system; })   //
            importShell (import ./shells/prolog.nix { inherit pkgs system; }) //
            importShell (import ./shells/python.nix { inherit pkgs system; }) //
            importShell (import ./shells/r.nix   { inherit pkgs system; }) //
            importShell (import ./shells/rust.nix   { inherit pkgs system; })
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

            ############################################################
            # Expose individual packages
            ############################################################
            allPkgs = nixpkgs.lib.flatten (map
                (sh: sh.packages)
                (nixpkgs.lib.attrValues shells)
            ) ++ import ./lib/libs.nix { inherit pkgs; };

            perPkg = nixpkgs.lib.listToAttrs (
            map (p: {
                name  = builtins.replaceStrings ["." "-"] ["_" "_"] p.name;
                value = pkgs.buildEnv { name = p.name; paths = [p]; };
                }) allPkgs
            );

            ############################################################
            # Download all packages
            ############################################################
            pkgNames = builtins.concatStringsSep " " (map (name: name) (builtins.attrNames perPkg));

            installScript = pkgs.writeShellScriptBin "install-all-devshell-packages" ''
            echo "Installing all devshell packages:"
            echo "  ${pkgNames}"

            # Remove old packages
            mkdir -p "$HOME"/.nix-profile-devshells
            rm -rf "$HOME"/.nix-profile-devshells/*

            # Install new packages
            # Unchanged packages will not be downloaded again as they still exist in the store
            for pkg in ${pkgNames}; do
                echo "Installing: ''${pkg}"
                nix profile add --profile "$HOME"/.nix-profile-devshells/''${pkg} "$HOME"/anatos/devshells#packages.${system}.''${pkg}
            done

            echo ""
            echo "✔ All devshell packages installed successfully."
            '';
        in
        perPkg // { installScript = installScript; }
        );
    };
}