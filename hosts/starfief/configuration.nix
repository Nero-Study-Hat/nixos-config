{ inputs, outputs, lib, config, pkgs, pkgs-stable, rootPath, ... }:

let
    secretspath = builtins.toString inputs.mysecrets;
in
{
	imports = [
		../../modules/core/desktop.nix
		./hardware-configuration.nix

		../../modules/roles/workstation/system-modules.nix
	];

    roles.workstation.system = {
        enable = true;
        hostname = "starfief";
		virtualization = false; # for quicker install
    };

	users.users = {
		alaric = {
			isNormalUser = true;
			hashedPasswordFile = config.sops.secrets."nero-user-password".path;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" ];
		};
	};

	programs.uwsm = {
		enable = true;
		waylandCompositors."hyprland" = {
			prettyName = "Hyprland";
			comment = "Hyprland compositor managed by UWSM";
			binPath = "/run/current-system/sw/bin/Hyprland";
		};
	};

	programs.zsh.enable = true;
	users.users.alaric.shell = pkgs.zsh;

	users.groups."realtime".members = [ "alaric" ];

	security.polkit.enable = true;
	services.printing.enable = true;
	boot.tmp.cleanOnBoot = true;

	networking.wireless = {
		enable = true;  # Enables wireless support via wpa_supplicant.
		userControlled.enable = true;
		allowAuxiliaryImperativeNetworks = true;  # Networks defined in aux imperitive networks (/etc/wpa_supplicant.conf)
	};

	environment.etc."wpa_supplicant.conf" = {
		source = config.sops.secrets.wpa_supplicant-conf.path;
	};

	networking.networkmanager.enable = false;

	environment.systemPackages = [
		pkgs.gparted
	];

}
