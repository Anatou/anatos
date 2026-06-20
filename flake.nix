{
    description = "AnatOs";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:nix-community/stylix/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
        nvf.url = "github:notashelf/nvf";
        devshells.url = "./devshells";

        # winapps = {
        #     url = "github:winapps-org/winapps";
        #     inputs.nixpkgs.follows = "nixpkgs";
        # };
    };

    outputs = { 
        self, 
        nixpkgs, 
        nixpkgs-unstable,
        nix-flatpak, 
        home-manager, 
        stylix, 
        nvf,
        devshells,
        # winapps,
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
                username = "vmuser";
            };
            "nixos_lab" = {
                system = "x86_64-linux";
                username = "lab";
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

                    pkgs-unstable =
                        import nixpkgs-unstable { system = cfg.system; allowUnfree = true; };
                };

                modules = [
                    ./hosts/${host}/configuration.nix
                    ./users/${cfg.username}/configuration.nix

                    home-manager.nixosModules.home-manager {
                        home-manager = {
                            backupFileExtension = "backup2";
                            extraSpecialArgs = {
                                inherit inputs host home-manager;
                                system = cfg.system;
                                username = cfg.username;
                                nixpkgs = nixpkgs;
                                # winapps = winapps;
                                devshells = devshells;
                                pkgs-unstable =
                                    import nixpkgs-unstable { system = cfg.system; allowUnfree = true; };
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
