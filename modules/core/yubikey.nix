{ inputs, options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    cfg = config.system-modules.yubikey;
in
{
    options.system-modules.yubikey = with types; {
        enable = mkEnableOption "Whether to setup yubikey support.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.yubikey-touch-detector ];
        services.udev.packages = [ pkgs.yubikey-personalization ];
        services.pcscd.enable = true;
    };
}