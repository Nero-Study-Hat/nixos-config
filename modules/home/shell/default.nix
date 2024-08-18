{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.shell;
in
{
    # if something grows in complexity and/or size then move it from this file to its own file to import
    # and extend the namespace declared in this file
    imports = [
        ./git.nix
        ./packages.nix
        ./language.nix
    ];

    options.home-modules.shell = with types; {
        enable-all = mkEnableOption "Enable all shell packages here.";

        direnv-enable = mkEnableOption "Enable direnv.";
        direnv-pkg = mkOption {
            type = package;
            default = pkgs.nix-direnv;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.enable-all)
        {
            home-modules.shell.language.bash-enable = true;
        })
        ( mkIf (cfg.enable-all || cfg.direnv-enable)
        {
            home.packages = [ cfg.direnv-pkg ];
            programs.direnv = {
                enable = true;
                enableBashIntegration = true;
                nix-direnv.enable = true;
            };
        })

        ( mkIf (cfg.enable-all || cfg.git-enable)
        {
            home.packages = with pkgs; [ git ];
            programs.git = {
                enable = true;
                userName = "Nero-Study-Hat";
                userEmail = "nerostudyhat@gmail.com";
            };
        })
    ];
}