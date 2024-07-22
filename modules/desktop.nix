{ lib, config, options, pkgs, ... }:

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
			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
			};
		})
	];
}