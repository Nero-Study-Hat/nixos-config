{ inputs, lib, pkgs, rootPath, ... }:

{
    imports = [
        ./hyprland.nix
        ./hyprlock.nix
        ./packages.nix
    ]
}