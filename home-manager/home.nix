{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ 
        # ./programs/plasma-manager.nix
        ../modules/home/hyprland.nix #TODO: conditional module for desktop

        ./packages.nix
        ./programs/bash.nix
        ./programs/git.nix
        ./programs/vscode.nix
    ];

	nixpkgs = {
		config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
        overlays = [ inputs.hyprland.overlays.default ];
	};

    home.username = "nero";
    home.homeDirectory = "/home/nero";

    home.keyboard.layout = "us";

    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
}