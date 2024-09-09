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
            monitors = [
                "eDP-1, 2240x1400@60, auto-left, 1.25" # main screen
            ];
			default-pkgs.install = true;
			waybar = {
				enable = true;
				output-monitor = "eDP-1";
				virt-desktops-modules.enable = true;
				c-modules = [ "battery" "custom/weather" "custom/activity" "group/group-virt-desktops" ];
				# c-modules = [ "custom/weather" ];
				height = 40;
			};
			virt-desktops.enable = true;
			hyprkool.enable = false;
		};
	};
}