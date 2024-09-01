{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ ../../modules/roles/workstation/home-modules.nix ];

    home.keyboard.layout = "us";

    roles.workstation.home = {
        enable = true;
        user = "alaric";
    };

	home-modules.desktop = {
		kde.enable = true;
		hyprland = {
			enable = true;
			hyprlock = {
				enable = true;
				wallpaper = "/home/alaric/...";
				profile = "/home/alaric/...";
			};
			hypridle.enable = true;
			# main PC
			# FIXME: move to stardom users and create for starfief
			monitors = [
				", preferred, auto, 1" # main screen
				# "" # second monitor sometimes attached
			];
			default-pkgs.install = true;
			waybar = {
				enable = true;
				virt-desktops-modules.enable = true;
				c-modules = [ "custom/weather" "custom/activity" "group/group-virt-desktops" ];
				# c-modules = [ "custom/weather" ];
			};
			virt-desktops.enable = true;
			hyprkool.enable = false;
		};
	};
}