{ inputs, options, config, lib, pkgs, pkgs-old, rootPath, ... }:

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
        ({
            environment.systemPackages = [
                pkgs.libguestfs
                pkgs.guestfs-tools
            ];
        })
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
            environment.systemPackages = [ pkgs.virt-manager ];
            virtualisation.libvirtd = {
                enable = true;
                qemu = {
                    package = pkgs.qemu_kvm;
                    vhostUserPackages = [ pkgs.virtiofsd ];
                    runAsRoot = true;
                    swtpm.enable = true;
                    ovmf = {
                        enable = true;
                        packages = [(pkgs.OVMF.override {
                            secureBoot = true;
                            tpmSupport = true;
                        }).fd];
                    };
                };
            };
        })
    ]);
}