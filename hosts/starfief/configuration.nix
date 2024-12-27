{ inputs, outputs, lib, config, pkgs, pkgs-stable, ... }:

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
    };

	users.users = {
		alaric = {
			isNormalUser = true;
			hashedPasswordFile = config.sops.secrets."nero-user-password".path;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" ];
		};
	};

	security.polkit.enable = true;
	services.printing.enable = true;
	boot.tmp.cleanOnBoot = true;

    networking.wireless = {
        enable = true;
        # secretsFile = config.sops.secrets.wifi-secrets-file.path;
        # environmentFile = "/etc/tmp_wifi_secrets";
        interfaces = [ "wlp2s0" ];
        userControlled.enable = true;
    };

	networking.networkmanager.enable = true;

	environment.systemPackages = [
		pkgs.gparted
	];

}