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

    #TODO: Handle the following as secrets to learn how.
    programs.git = {
        enable = true;
        userName = "Nero-Study-Hat";
        userEmail = "nerostudyhat@gmail.com";
    };

    programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            cl = "clear"; # yes I am this lazy, generally I ctrl+l
        };
    };

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
}