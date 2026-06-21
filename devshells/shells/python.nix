{ pkgs, system, ...}:
let
    mkPythonDevshell = (import ../lib/zsh-python-devshell.nix) { inherit pkgs; };
    mkBashDevShell = (import ../lib/bash-devshell.nix) { inherit pkgs; };
    prefix = "python";
in
{
    default = {
        prefix = prefix;
        function = mkPythonDevshell;
        name = "python3.15";
        packages = with pkgs; [ python315 python315Packages.uv jupyter-all ];
    };

    t = {
        prefix = prefix;
        function = mkPythonDevshell;
        name = "python3.15-free-threading";
        packages = with pkgs; [ python315FreeThreading ];
    };

    v315-nov = {
        prefix = prefix;
        function = mkPythonDevshell;
        name = "python3.15-no-venv";
        packages = with pkgs; [ python315 ];
        use-venv = false;
    };

    shell = {
        prefix = prefix;
        function = mkBashDevShell;
        name = "python3.13-shell";
        packages = with pkgs; [
            python315
        ];
        shellHook = "python; exit";
    };

    v315-bash = {
        prefix = prefix;
        function = mkBashDevShell;
        name = "python3.15-bash";
        packages = with pkgs; [ python315 jupyter-all ];
    };

    v314 = {
        prefix = prefix;
        function = mkPythonDevshell;
        name = "python3.14";
        packages = with pkgs; [ python314 ];
    };
}