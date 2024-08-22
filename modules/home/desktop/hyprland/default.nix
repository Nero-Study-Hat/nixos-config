{ inputs, options, config, lib, pkgs, rootPath, ... }:

{
    imports = [
        ./waybar
        ./hyprland.nix
        ./hyprlock.nix
        ./hypridle.nix
        ./packages.nix
    ];
}