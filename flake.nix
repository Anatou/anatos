{
    description = "AnatOs";

    inputs = {
        # NixOS official package source, using the nixos-25.05 branch here
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:nix-community/stylix/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
        nixpkgs-linux-firmware-downgrade.url = "github:NixOS/nixpkgs/732e4d32ad9fde9447d7cfca129b3afec7de00cc";
        nvf.url = "github:notashelf/nvf";
    };

    outputs = { 
        self, 
        nixpkgs, 
        nixpkgs-linux-firmware-downgrade, 
        nix-flatpak, 
        home-manager, 
        stylix, 
        nvf,
        ... 
    }@inputs: 
    let
        host_config = {
            "anatos" = {
                system = "x86_64-linux";
                username = "anatou";
            };
            "nixvm" = {
                system = "x86_64-linux";
                username = "anatou";
            };
        };
    in
    {
    # ========== NixOs configuration ========== #
    # build with sudo nixos-rebuild switch --flake .
    # or (same thing) sudo nixos-rebuild switch --flake .#nixosConfigurations.nixvm
    nixosConfigurations =
        nixpkgs.lib.mapAttrs
        (host: cfg:
            nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit inputs host;
                    username = cfg.username;
                    system = cfg.system;

                    pkgs-linux-firmware-downgrade =
                        import nixpkgs-linux-firmware-downgrade { system = cfg.system; allowUnfree = true; };
                };

                modules = [
                    ./hosts/${host}/configuration.nix
                    ./users/${cfg.username}/configuration.nix

                    home-manager.nixosModules.home-manager {
                        home-manager = {
                            backupFileExtension = "backup2";
                            extraSpecialArgs = {
                            inherit inputs host;
                            system = cfg.system;
                            username = cfg.username;
                            nixpkgs = nixpkgs;
                            };

                            users.${cfg.username}.imports = [
                            ./users/${cfg.username}/home.nix
                                nix-flatpak.homeManagerModules.nix-flatpak
                                stylix.homeModules.stylix
                                nvf.homeManagerModules.default
                            ];
                        };
                    }
                ];
            }
        )
        host_config;
    };
}
