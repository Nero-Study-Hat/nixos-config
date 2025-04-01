{ config, lib, pkgs, modulesPath, ... }:

{
	boot = {
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" "mt7921e" ];
		initrd.network.enable = true;
        kernelModules = [ "kvm-amd" ];
		kernelPackages = pkgs.linuxPackages_latest;
		supportedFilesystems = [ "ntfs" ];
		loader = {
			grub = {
				enable = true;
				efiSupport = true;
				device = "nodev";
			};
			efi.canTouchEfiVariables = true;
		};
	};

	# yubikey encryption setup; main resources for luks with yubikey setup below
	# https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS#LVM_setup
	# https://github.com/sgillespie/nixos-yubikey-luks
	# https://github.com/sgillespie/nixos-configs/tree/main/hosts
	boot.initrd = {
		kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
		luks = {
			# Support for Yubikey PBA
			yubikeySupport = true;
			devices."encrypted" = {
				device = "/dev/nvme0n1p2"; # luks device
				allowDiscards = true;
				yubikey = {
					slot = 2;
					twoFactor = false;
					gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
					keyLength = 64;
					saltLength = 16;

					storage = {
						device = "/dev/disk/by-label/UEFI"; # contains current salt
						fsType = "vfat";
						path = "/crypt-storage/default"; # path to file that contains salt and iterations on given device
					};
				};
			};
		};
	};


	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot".device = "/dev/disk/by-label/UEFI";
	fileSystems."/mnt/data".device = "/dev/disk/by-label/data";
	swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

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