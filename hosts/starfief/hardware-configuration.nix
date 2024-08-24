{ config, lib, pkgs, modulesPath, ... }:

{
	boot = {
		initrd.availableKernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "nvme" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
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

    luks = {
        # Support for Yubikey PBA
        yubikeySupport = true;

        devices."encrypted" = {
            device = "/dev/sdb5"; # Be sure to update this to the correct volume

            yubikey = {
                slot = 2;
                twoFactor = true; # Set to false for 1FA
                gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
                keyLength = 64; # Set to $KEY_LENGTH/8
                saltLength = 16; # Set to $SALT_LENGTH

                storage = {
                    device = "/dev/sdb1"; # Be sure to update this to the correct volume
                    fsType = "vfat";
                    path = "/crypt-storage/default";
                };
            };
        };
    };


    # File Systems Plan - storage is one 475 GiB drive
    # - 16 GiB: linux-swap (swap; LUKS with Yubikey encrypted)
    # - 150 GiB: nixos-root (ext4; LUKS with Yubikey encrypted)
    # - 500 MiB: nixos-boot (fat32)
    # - 500 MiB windows-boot (fat32)
    # - 75 GiB: windows (ntfs; Bitlocker encrypted)
    # - remaining GiB: datat (ntfs; LUKS with Yubikey encrypted)

	fileSystems."/".device = "/dev/disk/by-label/nixos";
	fileSystems."/boot/efi".device = "/dev/disk/by-label/NIXOS_EFI";

	fileSystems."/mnt/data" =
	{
		device = "/dev/disk/by-label/data";
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
}