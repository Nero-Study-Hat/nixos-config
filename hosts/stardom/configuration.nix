{ inputs, outputs, lib, config, pkgs, ... }:

{
	imports = [
		../../modules/core/desktop.nix
		./hardware-configuration.nix
	];

	desktop.choice = "hyprland";

	nix.settings = {
		substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

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

	# security.polkit.enable = true;
	# programs.dconf.enable = true;

	# enable sound with pipewire
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;

	nixpkgs.config.allowUnfree = true;

    programs.steam = {
        enable = true;
    };

	environment.systemPackages = with pkgs; [
		dotnetCorePackages.sdk_8_0_1xx
	];

	# # Virtualbox Setup
	virtualisation.virtualbox.host.enable = true;
	virtualisation.virtualbox.host.package = pkgs.virtualbox;
	users.extraGroups.vboxusers.members = [ "nero" ];
	virtualisation.virtualbox.host.enableExtensionPack = true;
	virtualisation.virtualbox.guest.enable = true;

	system.stateVersion = "24.05";
}
