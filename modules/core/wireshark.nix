{ inputs, options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

with lib;
let
    cfg = config.system-modules.wireshark;
in
{
    options.system-modules.wireshark = with types; {
        enable = mkEnableOption "Whether to enable wireshark.";
    };

    config = mkIf cfg.enable {
        programs.wireshark = {
            enable = true;
            package = pkgs-stable.wireshark;
            # Whether to allow users in the 'wireshark' group to capture network traffic. 
            dumpcap.enable = true;
            # Whether to allow users in the 'wireshark' group to capture USB traffic.
            usbmon.enable = false;
        };

        users.groups."wireshark".members = [ "nero" ];

        # plugins handled with home.files in user home.nix
    };
}