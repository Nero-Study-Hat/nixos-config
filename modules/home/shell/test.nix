{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.shell;
in
{
    options.home-modules.shell = with types; {
        defaults-enable = mkEnableOption "Enable condition one.";
        extra-enable = mkEnableOption "Enable condition two.";
        test-pkg = mkPackageOption {
            description = "What package to use.";
            default = pkgs.cowsay;
        };
    };

    config = mkIf cfg.defaults-enable || cfg.extra-enable (mkMerge [
        ({
            home.packages = [ cfg.mullvad-pkg ];
        })
    ]);
}