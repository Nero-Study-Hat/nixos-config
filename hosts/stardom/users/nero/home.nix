{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ 
        #TODO: conditional module for desktop
        ../../../../modules/home/desktop/hyprland

        ./packages.nix
        ../../../../modules/roles/workstation/home-modules.nix
        # ../../../../modules/home/shell
    ];

    home.username = "nero";
    home.homeDirectory = "/home/nero";

    home.keyboard.layout = "us";

    # home-modules.shell.git-enable = true; successfully installs

    nixpkgs = {
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
    };

    roles.workstation.home = {
        enable = true;
        desktop = "all";
    };

    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
}