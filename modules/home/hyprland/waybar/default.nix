{ lib, pkgs, ... }:

{
    # home.packages = with pkgs; [
    #     (pkgs.waybar.overrideAttrs (oldAttrs: {
    #         mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #         })
    #     )
    # ];

    programs.waybar.enable = true;
    programs.waybar.package = (pkgs.waybar.overrideAttrs (oldAttrs: {
                                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                                })
                              );

    programs.waybar.settings = {
        #
    }
}