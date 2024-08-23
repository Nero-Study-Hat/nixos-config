{ inputs, lib, config, options, pkgs, ... }:

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