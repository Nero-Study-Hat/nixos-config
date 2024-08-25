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
				device = "/dev/sdb5"; # encrypted lvm volume
				yubikey = {
					slot = 2;
					twoFactor = false;
					gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
					keyLength = 64;
					saltLength = 16;

					storage = {
						device = "/dev/sdb1"; # contains current salt
						fsType = "vfat";
						path = "/crypt-storage/default"; # path to file that contains salt and iterations on given device
					};
				};
			};
		};
	};

	# TODO: adjust for lvm partitioning
	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot/efi".device = "/dev/disk/by-label/NIXOS_EFI";
	swapDevices = [{ device = "/dev/disk/by-uuid/fa2d35b2-c349-42bd-b735-a5c71417f950"; }];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.enableRedistributableFirmware = true;
	hardware.cpu.amd.updateMicrocode = true;
}