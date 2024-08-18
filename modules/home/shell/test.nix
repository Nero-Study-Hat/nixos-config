{ options, config, lib, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.home-modules.shell.test;
    chosen-pkgs = if (cfg.pkgs-stable == true) then pkgs-stable else pkgs;
in
{
    options.home-modules.shell.test = with types; {
        enable = mkEnableOption "Enable this";
        pkgs-stable = mkEnableOption "Whether to us nixpkgs-stable as opposed to unstable.";
    };

    config = mkIf cfg.enable {
        home.packages = [ chosen-pkgs.cowsay ];
    };
}