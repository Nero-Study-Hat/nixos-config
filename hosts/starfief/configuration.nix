{ inputs, outputs, lib, config, pkgs, pkgs-stable, ... }:

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

	networking.wireless = {
		enable = true;
		environmentFile = config.sops.secrets.wifi-secrets-file.path;
		# environmentFile = "/etc/tmp_wifi_secrets";
		interfaces = [ "wlp2s0" ];
		userControlled.enable = true;
	};
	networking.wireless.networks = {
		"@HOME_SSID@" = {
			hidden = true;
			pskRaw = "@HOME_PSK@";
		};
		"@DND_SSID@" = {
			hidden = true;
			pskRaw = "@DND_PSK@";
		};
		"@RCOLLEGE_SSID@" = {
			hidden = true;
			# FIXME: below indentation not being created
			# in conf file "/run/wpa_supplicant/wpa_supplicant.conf" properly
			auth =
            ''
                eap=PEAP
                identity="@RCOLLEGE_ID@"
                password="@RCOLLEGE_PSWD@"
            '';
		};
	};
	networking.networkmanager.enable = false;

	environment.systemPackages = [
		pkgs.gparted
	];

}
