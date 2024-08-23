{ inputs, options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    cfg = config.system-modules.virtualization;
in
{
    options.system-modules.virtualization = with types; {
        enable = mkEnableOption "Whether to setup virtualization with associated pckgs and config.";
        user = mkOption {
            type = str;
            default = "nero";
        };
        virtualbox = mkEnableOption "Whether to setup virtualbox.";
        kvm-qemu = mkEnableOption "Whether to setup kvm-qemu.";
    };

    config = mkIf cfg.enable (mkMerge [
        ( mkIf (cfg.virtualbox)
        {
            virtualisation.virtualbox.host.enable = true;
            virtualisation.virtualbox.host.package = pkgs.virtualbox;
            users.extraGroups.vboxusers.members = [ cfg.user ];
            virtualisation.virtualbox.host.enableExtensionPack = true;
            virtualisation.virtualbox.guest.enable = true;
        })
        ( mkIf (cfg.kvm-qemu)
        {
            # stuff
        })
    ]);
}