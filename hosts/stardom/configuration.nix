{ inputs, outputs, lib, config, pkgs, ... }:

{
	imports = [
		../../modules/core/desktop.nix
		./hardware-configuration.nix

		../../../modules/roles/workstation/system-modules.nix
	];

    roles.workstation.home = {
        enable = true;
        hostname = "stardom";
		virtualisation = true;
		desktop = true;
    };

	users.users = {
		nero = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
		};
	};

	services.printing.enable = true;
	boot.tmp.cleanOnBoot = true;



### --------------------------------------------------------------------------
	#TODO: add package to home-modules gaming
    # programs.steam = {
    #     enable = true;
    # };

}
