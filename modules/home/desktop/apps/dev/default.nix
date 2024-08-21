{ options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

{
    imports = [
        ./editor.nix
        ./githup-desktop.nix
        ./godot.nix
    ];
}