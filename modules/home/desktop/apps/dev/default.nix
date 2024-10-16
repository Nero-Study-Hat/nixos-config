{ options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.dev;
in
{
    imports = [
        ./editor.nix
        ./githup-desktop.nix
        ./godot.nix
    ];

    options.home-modules.desktop.apps.dev = with types; {
        renpy-enable = mkEnableOption "Enable renpy visual novel engine.";
        renpy-pkg = mkOption {
            type = package;
            default = pkgs-stable.renpy;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.renpy-enable)
        {
            home.packages = [ cfg.renpy-pkg ];
        })
    ];
}