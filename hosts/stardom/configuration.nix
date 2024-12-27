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
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" "libvirtd" ];
		};
		bo = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" ];
		};
	};

	users.groups."realtime".members = [ "nero" ];

	networking.networkmanager.enable = true;

	services.printing.enable = true;
	boot.tmp.cleanOnBoot = true;

	security.polkit.enable = true;

	# gparted has to be installed in system config it seems
	#TODO: move gparted install into system-module
	environment.systemPackages = [
		pkgs.gparted
		pkgs.wine-wayland
		pkgs.winetricks
		pkgs.yabridge
		pkgs.yabridgectl
		pkgs.gamemode
	];

	# music I found to save
	# https://music.youtube.com/watch?v=LlltD3d2t0Q&list=OLAK5uy_l54s3hYsFz7oym06wkSERZOKtxqVJGRtg
	users.groups."gamemode".members = [ "nero" ];
	programs.gamemode = {
		enable = true;
		enableRenice = true;
		settings = {
			general = {
				softrealtime = "on";
				desiredgov = "performance";
				renice = 11;
				disable_splitlock = 1;
				pin_cores= "yes";
				inhibit_screensaver = 0;
			};
			custom = {
				start = "notify-send -a 'Gamemode' 'Optimizations activated'";
				end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
			};
		};
	};

	#TODO: add package to home-modules gaming
    # programs.steam = {
    #     enable = true;
    # };

}
