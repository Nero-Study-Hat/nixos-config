{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [ ];

	boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
	boot.initrd.kernelModules = [ ];
	boot.kernelModules = [ ];
	boot.extraModulePackages = [ ];

	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot/efi".device = "/dev/disk/by-label/boot";

	# Below line will be inserted by install script with appropiate UUID.
	# swapDevices = [{ device = "/dev/disk/by-uuid/81047232-91c5-44ab-9ded-0d4d0cf71888"; }];

	networking.useDHCP = lib.mkDefault true;
	# networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	virtualisation.virtualbox.guest.enable = true;
}