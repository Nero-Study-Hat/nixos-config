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

    # doesn't allow comments
    # programs.waybar.settings = lib.importJSON "${dirPath}/config.jsonc";

    # use for getting inicode icons => https://www.nerdfonts.com/cheat-sheet

    # nixlang specific
    programs.waybar.settings."mainbar" = {
        "layer" = "top";
        "modules-right" = ["clock"];

        "clock" = {
            "interval" = 60;
            "format" = "  {:%a %b %d  %H:%M}";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%Y-%m-%d}";
        };
    };

    # CSS style of the bar
    # programs.waybar.style = {
    #     #
    # };
}