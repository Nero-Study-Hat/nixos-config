{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ 
        #TODO: conditional module for desktop
        ../../../../modules/home/plasma-manager.nix
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

    home-modules.shell = {
        enable-all = true;
    };

    home.packages = with pkgs; [
        cascadia-code
        source-code-pro
        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk
        noto-fonts-cjk-sans
        noto-fonts-emoji
        font-awesome
    ];

    fonts.fontconfig.defaultFonts.emoji = ["Noto Color Emoji"];

    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
}