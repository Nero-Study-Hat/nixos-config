{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.shell;
in
{
    # if something grows in complexity and/or size then move it from this file to its own file to import
    # and extend the namespace declared in this file
    # imports = [ ];

    options.home-modules.shell = with types; {
        steam-enable = mkEnableOption "Enable steam.";
        steam-pkg = mkOption {
            type = package;
            default = pkgs.steam;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.steam-enable)
        { home.packages = [ cfg.steam-pkg ]; })
    ];
}