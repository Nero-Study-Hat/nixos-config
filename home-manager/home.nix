{ config, pkgs, lib, ... }:

{
    imports = [ 
        ./packages.nix
        ./programs/bash.nix
    ];

	nixpkgs = {
		config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
	};

    home.username = "nero";
    home.homeDirectory = "/home/nero";

    home.keyboard.layout = "us";

    programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            cl = "clear";
        };
        historyIgnore = [ "ls" "cd" "cl" "clear" "exit" ];
    };

    programs.home-manager.enable = true;
    home.stateVersion = "23.11";
}