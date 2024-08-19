{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.creative;
in
{
    # if something grows in complexity and/or size then move it from this file to its own file to import
    # and extend the namespace declared in this file
    # imports = [ ];

    options.home-modules.desktop.apps.creative = with types; {
        blender-enable = mkEnableOption "Enable blender.";
        blender-pkg = mkOption {
            type = package;
            default = pkgs.blender-hip;
            description = "Packake for blender 3D. User blender-hip for an amd device and just blender for without.";
        };
        krita-enable = mkEnableOption "Enable krita.";
        krita-pkg = mkOption {
            type = package;
            default = pkgs.krita;
        };
        aseprite-enable = mkEnableOption "Enable aseprite.";
        aseprite-pkg = mkOption {
            type = package;
            default = pkgs.aseprite;
        };
        davinci-resolve-enable = mkEnableOption "Enable davinci-resolve.";
        davinci-resolve-pkg = mkOption {
            type = package;
            default = pkgs.davinci-resolve;
        };
        pureref-enable = mkEnableOption "Enable pureref.";
        pureref-pkg = mkOption {
            type = package;
            default = pkgs.pureref;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.blender-enable)
        {
            home.packages = [ cfg.blender-pkg ];
        })
        ( mkIf (cfg.krita-enable)
        {
            home.packages = [ cfg.krita-pkg ];
        })
        ( mkIf (cfg.aseprite-enable)
        {
            home.packages = [ cfg.aseprite-pkg ];
        })
        ( mkIf (cfg.davinci-resolve-enable)
        {
            home.packages = [ cfg.davinci-resolve-pkg ];
        })
        ( mkIf (cfg.pureref-enable)
        {
            home.packages = [ cfg.pureref-pkg ];
        })
    ];
}