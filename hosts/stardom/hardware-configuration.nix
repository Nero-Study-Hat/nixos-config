{ config, lib, pkgs, modulesPath, ... }:

{
	boot = {
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
		initrd.kernelModules = [ "amdgpu" ];
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];

		kernelPackages = pkgs.linuxPackages_6_8;
		supportedFilesystems = [ "ntfs" ];
		loader = {
			efi = {
				efiSysMountPoint = "/boot/efi";
			};
			grub = {
				efiSupport = true;
				efiInstallAsRemovable = true;
				device = "nodev";
			};
		};
	};


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
			"umask=002"
			"0"
			"2"
		];
	};

	swapDevices = [{ device = "/dev/disk/by-uuid/fa2d35b2-c349-42bd-b735-a5c71417f950"; }];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.enableRedistributableFirmware = true;
	hardware.cpu.amd.updateMicrocode = true;

	hardware.graphics = {
		enable = true;

		# For AMD vulkan support
		# driSupport = true;
		enable32Bit = true;

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