{ inputs, options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

{
    imports = [
        ./waybar
        ./hyprland.nix
        ./hyprlock.nix
        ./hypridle.nix
        ./packages.nix
        ./plugins
    ];
}