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
            default = pkgs.github-desktop;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.githup-desktop-enable)
        {
            home.packages = [ cfg.githup-desktop-pkg ];
        })
    ];
}