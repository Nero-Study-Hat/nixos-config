{ inputs, outputs, lib, config, pkgs, ... }:

{
	# no hard-configuration.nix because this will be used by nixos-generator to
	# build an iso which does its own thing to work on a bunch of different hardware
	imports = [
		../../modules/core/desktop.nix
	];

	desktop.choice = "hyprland";

	nix.settings = {
		substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

		experimental-features = "nix-command flakes";
		# Deduplicate and optimize nix store
		auto-optimise-store = true;
	};

	networking.hostName = "isoimage";
	networking.useDHCP = lib.mkDefault true;
	networking.networkmanager.enable = true;

	time.timeZone = "America/New_York";

	boot.kernelPackages = pkgs.linuxPackages_6_8;
	boot.supportedFilesystems = [ "ntfs" ];
	boot.loader = {
		efi = {
			efiSysMountPoint = "/boot/efi";
		};
		grub = {
			efiSupport = true;
			efiInstallAsRemovable = true;
			device = "nodev";
		};
	};

	users.users = {
		nixer = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [
							"wheel" "video" "audio" "disk" "networkmanager" 
						];
		};
	};

	# enable sound with pipewire
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};

	system.stateVersion = "24.05";
}
