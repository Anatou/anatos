{ lib, config, pkgs, wayscriber, ...}:
let
wayscriberPackages = wayscriber.packages.${pkgs.stdenv.hostPlatform.system};

# We skip the tests because the sandbox for testing causes compiling errors
wayscriber-notest = wayscriberPackages.wayscriber.overrideAttrs (_: { doCheck = false; });
wayscriber-configurator-notest = wayscriberPackages.wayscriber-configurator.overrideAttrs (_: { doCheck = false; });

in
{
    options.my.home.programs.wayscriber.enable = lib.mkEnableOption "Enable my wayscriber configuration";

    config = lib.mkIf config.my.home.programs.wayscriber.enable {
        home.packages = with pkgs; [
            wayscriber-notest
            wayscriber-configurator-notest
        ];
        systemd.user.packages = [ wayscriber-notest ];
    };
}