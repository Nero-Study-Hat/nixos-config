{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [ ];

	boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
	boot.initrd.kernelModules = [ "amdgpu" ];

	boot.kernelModules = [ "kvm-amd" ];
	boot.extraModulePackages = [ ];

	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot/efi".device = "/dev/disk/by-label/NIXOS_EFI";

	fileSystems."/mnt/nero-priv-data".device = "/dev/disk/by-label/nero-priv-data";
	fileSystems."/mnt/nero-pub-data" =
	{
		device = "/dev/disk/by-label/nero-pub-data";
		fsType = "ntfs";
		options = [
			"ntfs-3g"
			"uid=1000"
			"gid=100"
			"umask=0022"
			"0"
			"2"
		];
	};
	# fileSystems."/mnt/nero-pub-data".device = "/dev/disk/by-label/nero-pub-data";

	swapDevices = [{ device = "/dev/disk/by-uuid/fa2d35b2-c349-42bd-b735-a5c71417f950"; }];

	networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.amd.updateMicrocode = true;
	hardware.enableRedistributableFirmware = true;

	hardware.opengl = {
		enable = true;

		# For AMD vulkan support
		driSupport = true;
		driSupport32Bit = true;

		extraPackages = with pkgs; [
			amdvlk
			rocmPackages.clr.icd
		];

		# For 32 bit applications 
		# Only available on unstable
		extraPackages32 = with pkgs; [
			driversi686Linux.amdvlk
		];
	};

	environment.variables.AMD_VULKAN_ICD = "RADV";
}