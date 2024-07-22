{ inputs, config, ... }:

{
	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "amdgpu" ];
	services.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;

	# keep in mind home-manager modules for kde

}

# { inputs, config, ... }:

# {
# 	options = {
# 		enable = mkOption {
# 			type = types.bool;
# 			default = false;
# 			description = "Enable wayland";
# 		};
# 	}
# }