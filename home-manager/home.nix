{ config, pkgs, lib, ... }:

{
    imports = [ ./packages/main.nix ];

    home.username = "nero";
    home.homeDirectory = "/home/nero";

    home.keyboard.layout = "us";

    home.packages = with pkgs; [
        # Basics
        brave
    ];

    programs = {
        tmux.enable = true;
        htop.enable = true;

        home-manager.enable = true;
    };

    home.stateVersion = "23.11";
}