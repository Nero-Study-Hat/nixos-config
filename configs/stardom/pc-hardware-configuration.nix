{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [ ];

	boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
	boot.initrd.kernelModules = [ ];
	boot.kernelModules = [ ];
	boot.extraModulePackages = [ ];

	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot/efi".device = "/dev/disk/by-label/NIXOS_EFI";

	fileSystems."/mnt/nero-priv-data".device = "/dev/disk/by-label/nero-priv-data";
	fileSystems."/mnt/nero-pub-data".device = "/dev/disk/by-label/nero-pub-data";

	swapDevices = [{ device = "/dev/disk/by-uuid/fa2d35b2-c349-42bd-b735-a5c71417f950"; }];

	networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}