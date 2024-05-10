{ config, pkgs, lib, plasma-manager, ... }:

{
    imports = [ 
        ./programs/test.nix
        
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
    home.stateVersion = "23.11";

    # programs.plasma = {
    #     enable = true;

    #     workspace = {
    #         clickItemTo = "select";
    #         lookAndFeel = "org.kde.breezedark.desktop";
    #         #   cursorTheme = "Bibata-Modern-Ice";
    #         #   iconTheme = "Papirus-Dark";
    #         #   wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    #     };


    #     shortcuts = {
    #         kwin = {
    #             "Expose" = "Meta+,";
    #             "Switch Window Down" = "Ctrl+Alt+Down";
    #             "Switch Window Left" = "Ctrl+Alt+Left";
    #             "Switch Window Right" = "Ctrl+Alt+Right";
    #             "Switch Window Up" = "Ctrl+Alt+Up";
    #             "Show Desktop Grid" = "Meta+A";
    #         };
    #     };


    #     configFile = {
    #         "kwinrc"."Desktops"."Number" = {
    #             value = 4;
    #             # Forces kde to not change this value (even through the settings app).
    #             immutable = true;
    #         };
    #         "kwinrc"."Desktops"."Rows" = {
    #             value = 2;
    #             immutable = true;
    #         };
    #         "kwinrc"."Windows"."RollOverDesktops" = {
    #             value = true;
    #             immutable = true;
    #         };
    #         "kwinrc"."Plugins"."bismuthEnabled" = {
    #             value = true;
    #             immutable = true;
    #         };
    #     };
    # };
}