{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.dev;
in
{
    options.home-modules.desktop.apps.dev = with types; {
        githup-desktop-enable = mkEnableOption "Enable githup-desktop.";
        githup-desktop-pkg = mkOption {
            type = package;
            default = pkgs.githup-desktop;
        };
    };

    config = cfg.github-desktop-enable {
        home.packages = [ cfg.githup-desktop-pkg ];
    };
}