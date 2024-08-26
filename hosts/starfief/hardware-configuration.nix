{ config, lib, pkgs, modulesPath, ... }:

{
	boot = {
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
        kernelModules = [ "kvm-amd" ];

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
				enableCryptodisk = true;
			};
		};
	};

	# main resources for luks with yubikey setup
	# https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS#LVM_setup
	# https://github.com/sgillespie/nixos-yubikey-luks

	boot.initrd = {
		# Required to open the EFI partition and Yubikey
		kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
		luks = {
			# Support for Yubikey PBA
			yubikeySupport = true;
			devices."encrypted" = {
				device = "/dev/nvme0n1p2"; # encrypted lvm volume
				yubikey = {
					slot = 2;
					twoFactor = false;
					gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
					keyLength = 64;
					saltLength = 16;

					storage = {
						device = "/dev/nvme0n1p1"; # contains current salt
						fsType = "vfat";
						path = "/crypt-storage/default"; # path to file that contains salt and iterations on given device
					};
				};
			};
		};
	};

	# TODO: adjust for lvm partitioning
	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot/efi".device = "/dev/disk/by-label/UEFI";
	swapDevices = [{ device = "/dev/disk/by-uuid/31f4e844-b5f0-4c88-b1b8-e35f29340f65"; }];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.enableRedistributableFirmware = true;
	hardware.cpu.amd.updateMicrocode = true;
}