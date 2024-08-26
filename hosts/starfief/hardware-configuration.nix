{ config, lib, pkgs, modulesPath, ... }:

### THIS CONFIG WORKED ###

{
	boot = {
		initrd = {
			availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
			# Required to open the EFI partition and Yubikey
			kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
			luks = {
				# Support for Yubikey PBA
				yubikeySupport = true;
				devices."encrypted" = {
					device = "/dev/disk/by-uuid/33e4b793-8e49-4f01-836d-a9db50af1b62"; # luks device
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
        kernelModules = [ "kvm-amd" ];

		# kernelPackages = pkgs.linuxPackages_6_8;
		kernelPackages = pkgs.linuxKernel.packages.linux_6_1;
		supportedFilesystems = [ "ntfs" ];
		loader = {
			grub = {
				enable = true;
				efiSupport = true;
				device = "nodev";
				# efiInstallAsRemovable = true;
				# enableCryptodisk = true;
			};
			efi.canTouchEfiVariables = true;
		};
	};

	# main resources for luks with yubikey setup
	# https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS#LVM_setup
	# https://github.com/sgillespie/nixos-yubikey-luks


	# TODO: adjust for lvm partitioning
	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot".device = "/dev/disk/by-label/UEFI";
	swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.enableRedistributableFirmware = true;
	hardware.cpu.amd.updateMicrocode = true;
}