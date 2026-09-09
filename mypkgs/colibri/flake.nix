{
    description = "colibrì LLM engine with web dashboard";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        colibri = {
            url = "github:JustVugg/colibri";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, colibri, ... }:
    let
        forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    in {
        packages = forAllSystems (system:
        let
            pkgs = import nixpkgs { inherit system; };

            webUI = pkgs.buildNpmPackage {
                pname = "colibri";
                version = "1.10.2";
                src = "${colibri}/web";
                npmDepsHash = "sha256-dSBj0ugEctPY18JWe5ajsVQFy2kWvgLYLzuwIs39HLs=";
                installPhase = "cp -r dist $out";
            };
        in {
            default = colibri.packages.${system}.default.overrideAttrs (old: {
                installPhase = old.installPhase + ''
                    mkdir -p $out/lib/web
                    cp -r ${webUI} $out/lib/web/dist
                '';
            });
        });
    };
}