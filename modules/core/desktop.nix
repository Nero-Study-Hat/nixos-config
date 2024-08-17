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
			# qt = {
			# 	enable = true;
			# 	platformTheme = "qt5ct";
			# 	style = "kvantum";
			# };
		})

		( lib.mkIf (cfg.choice == "kde" || cfg.choice == "all")
		{
			services.xserver.desktopManager.plasma5.enable = true;
		})

		( lib.mkIf (cfg.choice == "hyprland" || cfg.choice == "all")
		{
			services.displayManager.sddm.wayland.enable = true;			

			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
				portalPackage = pkgs.xdg-desktop-portal-hyprland;
				package = inputs.hyprland.packages.${pkgs.system}.hyprland;
			};

			services.dbus.enable = true;
			xdg.portal = {
				enable = true;
				wlr.enable = true;
				extraPortals = [ 
					pkgs.xdg-desktop-portal-wlr
					pkgs.xdg-desktop-portal-gtk
				];
			};
		})
	];
}