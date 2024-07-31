{ inputs, lib, pkgs, rootPath, ... }:

{
    imports = [
        ./hyprland.nix
        ./hyprlock.nix
        ./hypridle.nix
        ./packages.nix
    ];
}