{ inputs, options, config, lib, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [
        ../../home/shell
        
        ../../home/desktop/kde
        ../../home/desktop/hyprland

        ../../home/desktop/apps/basics
        ../../home/desktop/apps/creative
        ../../home/desktop/apps/dev
        ../../home/desktop/apps/utility
        ../../home/desktop/gaming
    ];
}