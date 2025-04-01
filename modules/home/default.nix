{ inputs, options, config, lib, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [
        ./shell
        
        ./desktop/kde
        ./desktop/hyprland

        ./desktop/apps/basics
        ./desktop/apps/creative
        ./desktop/apps/dev
        ./desktop/apps/utility
        ./desktop/gaming
    ];
}