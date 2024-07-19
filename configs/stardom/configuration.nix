{ inputs, outputs, lib, config, pkgs, ... }:

{
	imports = [
		./pc-hardware-configuration.nix
		outputs.nixosModules.kde
	];

	nix.settings = {
		experimental-features = "nix-command flakes";
		# Deduplicate and optimize nix store
		auto-optimise-store = true;
	};

	networking.hostName = "stardom";
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
		nero = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [
							"wheel" "video" "audio" "disk" "networkmanager" 
						];
		};
	};

	nixpkgs.config.allowUnfree = true;

	programs.java.enable = true; 
    programs.steam = {
        enable = true;
    };

	environment.systemPackages = with pkgs; [
		dotnetCorePackages.sdk_8_0_2xx
	];

	# # Virtualbox Setup
	virtualisation.virtualbox.host.enable = true;
	virtualisation.virtualbox.host.package = pkgs.virtualbox;
	users.extraGroups.vboxusers.members = [ "nero" ];
	virtualisation.virtualbox.host.enableExtensionPack = true;
	virtualisation.virtualbox.guest.enable = true;

	system.stateVersion = "24.05";
}
