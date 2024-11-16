{ inputs, outputs, lib, config, pkgs, ... }:

{
	imports = [
		../../modules/core/desktop.nix
		./hardware-configuration.nix

		../../modules/roles/workstation/system-modules.nix
	];

    roles.workstation.system = {
        enable = true;
        hostname = "stardom";
    };

	users.users = {
		nero = {
			isNormalUser = true;
			hashedPasswordFile = config.sops.secrets."nero-user-password".path;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" ];
		};
		bo = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" ];
		};
	};

	networking.networkmanager.enable = true;

	security.polkit.enable = true;
	services.printing.enable = true;
	boot.tmp.cleanOnBoot = true;

	# gparted has to be installed in system config it seems
	#TODO: move gparted install into system-module
	environment.systemPackages = [
		pkgs.gparted
		pkgs.wine-wayland
		pkgs.winetricks
		pkgs.yabridge
		pkgs.yabridgectl
	];


	#TODO: add package to home-modules gaming
    # programs.steam = {
    #     enable = true;
    # };

}
