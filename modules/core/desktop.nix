{ inputs, lib, config, options, pkgs, ... }:

let
    cfg = config.desktop;
in
{
    options.desktop = {
		choice = lib.mkOption {
			type = lib.types.str;
			default = "kde";
			example = "hyprland";
			description = "The DE or WM with associated packages and config to setup.";
		};
    };

	config = lib.mkMerge [
		({
			services.xserver.enable = true;
			services.xserver.videoDrivers = [ "amdgpu" ];
			services.displayManager.sddm.enable = true;
		})

		(lib.mkIf (cfg.choice == "kde")
		{
			# services.xserver.enable = true;
			# services.xserver.videoDrivers = [ "amdgpu" ];
			# services.displayManager.sddm.enable = true;
			services.xserver.desktopManager.plasma5.enable = true;

			# keep in mind home-manager modules for kde
		})

		(lib.mkIf (cfg.choice == "hyprland")
		{
			# sddm session log in handling
			# services.xserver.enable = true; # for Xwayland
			# services.xserver.videoDrivers = [ "amdgpu" ];
			# services.displayManager.sddm.enable = true;
			services.displayManager.sddm.wayland.enable = true;

			# greetd session log in handling
			# services.xserver.enable = false;
			# services.greetd = {
			# 	enable = true;
			# 	settings = {
			# 		default_session = {
			# 			user = "nero";
			# 			command = "Hyprland";
			# 		};
			# 	};
			# };

			# security.pam.services.swaylock = {};
			

			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
				portalPackage = pkgs.xdg-desktop-portal-hyprland;
				package = inputs.hyprland.packages.${pkgs.system}.hyprland;
			};

			# for desktop program interations with each other
			services.dbus.enable = true;
			xdg.portal = {
				enable = true;
				extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
			};
		})
	];
}