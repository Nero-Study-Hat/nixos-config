{ config, pkgs, lib, plasma-manager, pkgs-stable, rootPath, ... }:

{
    imports = [ 
        # ./programs/plasma-manager.nix
        ./programs/hyprland.nix
        ./packages.nix
        ./programs/bash.nix
        ./programs/git.nix
        ./programs/vscode.nix
    ];

	nixpkgs = {
		config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
	};

    home.username = "nero";
    home.homeDirectory = "/home/nero";

    home.keyboard.layout = "us";

    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
}