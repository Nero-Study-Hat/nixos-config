{ config, pkgs, lib, ... }:

{
    imports = [ ./packages/main.nix ];

    home.username = "nero";
    home.homeDirectory = "/home/nero";

    home.keyboard.layout = "us";

    programs.home-manager.enable = true;
    home.stateVersion = "23.11";
}