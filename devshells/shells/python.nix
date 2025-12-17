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
        name = "python-3.13";
        packages = with pkgs; [ python313 jupyter-all ];
    };

    v310 = {
        prefix = prefix;
        function = mkPythonDevshell;
        name = "python-3.10";
        packages = with pkgs; [ python310 jupyter-all ];
    };

    v314t = {
        prefix = prefix;
        function = mkPythonDevshell;
        name = "python-3.14-free-threading";
        packages = with pkgs; [ python314FreeThreading ];
    };

    v313-nov = {
        prefix = prefix;
        function = mkPythonDevshell;
        name = "python3.13-no-venv";
        packages = with pkgs; [ python313 ];
        use-venv = false;
    };

    shell = {
        prefix = prefix;
        function = mkBashDevShell;
        name = "python3.13-shell";
        packages = with pkgs; [
            python313
        ];
        shellHook = "python; exit";
    };
}