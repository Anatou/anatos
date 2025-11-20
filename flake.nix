{
    description = "AnatOs";

    inputs = {
        # NixOS official package source, using the nixos-25.05 branch here
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
        nixpkgs-linux-firmware-downgrade.url = "github:NixOS/nixpkgs/732e4d32ad9fde9447d7cfca129b3afec7de00cc";
    };

    outputs = { self, nixpkgs, home-manager, nix-flatpak, nixpkgs-linux-firmware-downgrade, ... }@inputs: 
    let
        system = "x86_64-linux";
        host = "anatos";
        username = "anatou";
    in
    {
        # ========== NixOs configuration ========== #
        # build with sudo nixos-rebuild switch --flake .
        # or (same thing) sudo nixos-rebuild switch --flake .#nixosConfigurations.nixvm
        nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
            
            specialArgs = { 
                inherit inputs system host username; 
                pkgs-linux-firmware-downgrade = import nixpkgs-linux-firmware-downgrade { 
                    inherit system; allowUnfree = true;
                };
            };
            modules = [
                ./hosts/${host}/configuration.nix
                ./users/${username}/configuration.nix
                # ./users/home-manager.nix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        backupFileExtension = "backup";
                        extraSpecialArgs = { inherit inputs system username host; };
                        users.${username}.imports = [
                            ./users/${username}/home.nix 
                            nix-flatpak.homeManagerModules.nix-flatpak
                        ];
                    };
                }
            ];
        };
        # ========== home-manager configuration ========== #
        # build with home-manager switch --flake .
        # or (same thing) home-manager switch --flake .#homeConfigurations.anatou
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { inherit inputs system username host; };
            extraSpecialArgs = { inherit inputs system username host; };
            modules = [
                ./users/${username}/home.nix
            ];
        };
    };
}
