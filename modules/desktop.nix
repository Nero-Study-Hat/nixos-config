{ lib, config, options, pkgs, hyprland, ... }:

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
		(lib.mkIf (cfg.choice == "kde")
		{
			services.xserver.enable = true;
			services.xserver.videoDrivers = [ "amdgpu" ];
			services.displayManager.sddm.enable = true;
			services.xserver.desktopManager.plasma5.enable = true;

			# keep in mind home-manager modules for kde
		})

		(lib.mkIf (cfg.choice == "hyprland")
		{
			nix.settings = {
				substituters = ["https://hyprland.cachix.org"];
				trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
			};

			services.xserver.displayManager.sddm.enable = true;
			services.xserver.displayManager.sddm.wayland.enable = true;
			services.xserver.enable = true; # for Xwayland
			services.xserver.videoDrivers = [ "amdgpu" ];
			services.dbus.enable = true;

			programs.dconf.enable = true;

			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
				portalPackage = pkgs.xdg-desktop-portal-hyprland;
				systemd.setPath.enable = true;
				hyprlock.enable = true;
				package = hyprland.packages.${pkgs.system}.hyprland;
			};
			

			environment.sessionVariables = {
				ELECTRON_OZONE_PLATFORM_HINT = "auto";
				NIXOS_OZONE_WL = "1";
				MOZ_ENABLE_WAYLAND = "1";
			};

			environment.systemPackages = with pkgs; [
				hyprcursor
				hyprpaper
				hyprpicker     # screen-space color picker
				hyprshade      # to apply shaders to the screen
				hyprshot       # instead of grim(shot) or maim/slurp
				mako           # dunst for wayland
				libnotify

				## Utilities
				gromit-mpx     # for drawing on the screen
				pamixer        # for volume control
				wf-recorder    # screencasting
				wlr-randr      # for monitors that hyprctl can't handle
				xorg.xrandr    # for XWayland windows
			];

			xdg.portal = {
				enable = true;
				extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
			};

			# systemd.user.targets.hyprland-session = {
			# 	unitConfig = {
			# 		Description = "Hyprland compositor session";
			# 		Documentation = [ "man:systemd.special(7)" ];
			# 		BindsTo = [ "graphical-session.target" ];
			# 		Wants = [ "graphical-session-pre.target" ];
			# 		After = [ "graphical-session-pre.target" ];
			# 	};
			# };
		})
	];
}