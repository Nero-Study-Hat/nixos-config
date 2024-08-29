{ inputs, outputs, lib, config, pkgs, ... }:

{
	imports = [
		../../modules/core/desktop.nix
		./hardware-configuration.nix

		../../modules/roles/workstation/system-modules.nix
	];

    roles.workstation.system = {
        enable = true;
        hostname = "starfief";
    };

	users.users = {
		alaric = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" ];
		};
	};

	security.polkit.enable = true;
	services.printing.enable = true;
	boot.tmp.cleanOnBoot = true;

	networking.wireless.enable = true;
	networking.wireless.networks = {
		"home" = {
			hidden = true;
			auth = ''
				key_mgmt=WPA-PSK
				identity=${config.sops.secrets."wifi/home-name".content}
				password=${config.sops.secrets."wifi/home-password".content}
			'';
		};
	};

	environment.systemPackages = [
		pkgs.gparted
	];

}
