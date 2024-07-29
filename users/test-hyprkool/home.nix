{ inputs, lib, config, pkgs, pkgs-stable, ... }:

{
    imports = [
        ./hyprland-test.nix #TODO: conditional module for desktop

        ./packages.nix
        ../../modules/home/bash.nix
        ../../modules/home/git.nix
        ../../modules/home/vscode.nix
    ];

	nixpkgs = {
		config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
	};

    home.username = "tester";
    home.homeDirectory = "/home/tester";

    home.keyboard.layout = "us";

    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
}