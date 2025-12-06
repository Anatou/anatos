{ pkgs ? import <nixpkgs> {} }:
let 
    lib = pkgs.lib;
    python313Packages = pkgs.python313Packages;
in
python313Packages.buildPythonApplication rec {
    pname = "meteofrance-daemon";
    version = "0.1.0";
    pyproject = true;
    doCheck = false;

    src = ./.;

    build-system = with python313Packages; [ setuptools ];
    dependencies = with python313Packages; [ requests ];

    meta = {
        description = "A daemon gathering meteofrance's live weather forecast";
        #homepage = "https";
        #license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
            Anatou
        ];
    };
}