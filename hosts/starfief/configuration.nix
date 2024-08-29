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
	networking.wireless.environmentFile = config.sops.secrets.wifi-secrets-file.path;
	networking.wireless.networks = {
		"home" = {
			hidden = true;
			authProtocols = "WPA-PSK";
			priority = 1;
			auth = ''
				key_mgmt=WPA-PSK
				identity="@HOME_SSID"
				password="@HOME_PSK@"
			'';
		};
	};

	environment.systemPackages = [
		pkgs.gparted
	];

}
