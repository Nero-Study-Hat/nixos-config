{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.shell;
in
{
    options.home-modules.shell = with types; {
        defaults-enable = mkEnableOption "Enable condition one.";
        extra-enable = mkEnableOption "Enable condition two.";
        test-pkg = mkOption {
            type = package;
            default = pkgs.cowsay;
            description = ''
                Package derivation to use.
            '';
        };
    };

    config = mkIf cfg.defaults-enable (mkMerge [
        ({
            home.packages = [ cfg.test-pkg ];
        })
    ]);
}