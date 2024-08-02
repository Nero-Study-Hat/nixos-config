{ lib, pkgs, rootPath, ... }:

let
    configJson = builtins.fromJSON (builtins.readFile "./config.json");
    dirPath = "${rootPath}/modules/home/hyprland/waybar";
in
{


    programs.waybar.enable = true;
    programs.waybar.package = (pkgs.waybar.overrideAttrs (oldAttrs: {
                                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                                })
                              );

    # configuration of the bar
    programs.waybar.settings = (builtins.readFile "${dirPath}/config.jsonc");

    # CSS style of the bar
    programs.waybar.style = {
        #
    };
}