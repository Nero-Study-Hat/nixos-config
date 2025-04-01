{ inputs, options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    cfg = config.system-modules.tailscale;
in
{
    options.system-modules.tailscale = with types; {
        enable = mkEnableOption "Enable tailscale VPN service.";
    };

    config = mkIf cfg.enable {
        services.tailscale = {
            enable = true;
            package = pkgs.tailscale;
        };
    };
}