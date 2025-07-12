{ inputs, lib, config, options, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.system-modules.desktop;
in
{
    options.system-modules.desktop = with types; {
        kde = mkOption {
            type = bool;
            default = true;
            description = "Enable kde desktop environment with associated packages and config.";
        };
        hyprland = mkOption {
            type = bool;
            default = true;
            description = "Enable hyprland with associated packages and config.";
        };
        sddm = mkOption {
            type = bool;
            default = true;
            description = "Enable sddm.";
        };
    };

	config = mkMerge [
		({
			services.xserver.enable = true;
			services.xserver.videoDrivers = [ "amdgpu" ];
		})

		( mkIf (cfg.sddm)
		{
			services.displayManager.sddm.enable = true;
		})

		( mkIf (cfg.kde)
		{
			services.xserver.desktopManager.plasma5.enable = true;
		})

		( mkIf (cfg.hyprland)
		{
			services.displayManager.sddm.wayland.enable = true;			

			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
				package = pkgs-stable.hyprland;
				portalPackage = pkgs-stable.xdg-desktop-portal-hyprland;
				withUWSM = true;
			};

			services.dbus.enable = true;
			xdg.portal = {
				enable = true;
				wlr.enable = true;
				extraPortals = [ 
					pkgs-stable.xdg-desktop-portal-wlr
					pkgs-stable.xdg-desktop-portal-gtk
				];
			};
		})
	];
}