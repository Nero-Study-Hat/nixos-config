{ lib, config, options, pkgs, ... }:

let
    cfg = config.desktop;
in
{
    options.mytest = {
		choice = lib.mkOption {
			type = lib.types.str;
			default = "boo";
			example = "hollywood";
			description = "The package to be installed.";
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