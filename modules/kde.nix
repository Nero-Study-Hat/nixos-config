{ inputs, lib, config, pkgs, ... }:

{
	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "amdgpu" ];
	services.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;

	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "amdgpu" ];
	services.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;

	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;
	};
}