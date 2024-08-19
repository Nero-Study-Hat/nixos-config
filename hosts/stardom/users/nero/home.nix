{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ 
        #TODO: conditional module for desktop
        ../../../../modules/home/desktop/kde/plasma-manager.nix
        ../../../../modules/home/hyprland

        ./packages.nix
        ../../../../modules/roles/workstation/home-modules.nix
    ];

	nixpkgs = {
		config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
	};

    home.username = "nero";
    home.homeDirectory = "/home/nero";

    home.keyboard.layout = "us";

    roles.workstation = {
        home.enable = true;
        home.desktop = "all";

        # home = {
        #     enable = true;
        #     desktop = "all";
        #     default-creative-apps = false;
        # };
    };

    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
}