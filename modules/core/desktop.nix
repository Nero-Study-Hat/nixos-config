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
			# sddm session log in handling
			# services.displayManager.sddm.enable = true;
			# services.displayManager.sddm.wayland.enable = true;
			# services.xserver.enable = true; # for Xwayland
			# services.xserver.videoDrivers = [ "amdgpu" ];

			# greetd session log in handling
			services.xserver.enable = false;
			services.greetd = {
				enable = true;
				settings = {
					default_session = {
						user = "nero";
						command = "Hyprland";
					};
				};
			};

			security.pam.services.swaylock = {};
			

			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
				portalPackage = pkgs.xdg-desktop-portal-hyprland;
				package = inputs.hyprland.packages.${pkgs.system}.hyprland;
			};
			

			# environment.sessionVariables = {
			# 	NIXOS_OZONE_WL = "1";
			# };

			environment.systemPackages = with pkgs; [
				swww           # wallpaper daemon
				rofi-wayland   # app launcher
				hyprcursor

				kitty          # hyprland's default terminal

				hyprlock       # *fast* lock screen
				hyprpicker     # screen-space color picker
				# hyprshade      # to apply shaders to the screen
				# hyprshot       # instead of grim(shot) or maim/slurp

				# notifications
				mako           # notification daemon
				libnotify

				## Utilities
				# gromit-mpx     # for drawing on the screen
				# pamixer        # for volume control
				# wf-recorder    # screencasting
				# wlr-randr      # for monitors that hyprctl can't handle
				# xorg.xrandr    # for XWayland windows

				(pkgs.waybar.overrideAttrs (oldAttrs: {
					mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
					})
				)
			];

			# for desktop program interations with each other
			services.dbus.enable = true;
			xdg.portal = {
				enable = true;
				extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
			};
		})
	];
}