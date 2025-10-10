{
  description = "AnatOs";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.config.allowUnfree = true;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
      host = "vm";
      username = "anatou";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
    # ========== NixOs configuration ========== #
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system host username pkgs; };
      modules = [
        ./hosts/${host}/configuration.nix
      ];
    };
    # ========== home-manager configuration ========== #
    homeConfiguration.${username} = {
      specialArgs = { inherit inputs system host username pkgs; };
      modules = [
        ./users/${username}/configuration.nix
      ];
    }
  };
}
