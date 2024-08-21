{ pkgs, pkgs-stable, rootPath, ... }:

let
    godot4-mono = pkgs.callPackage "${rootPath}/pkgs/godot4-mono" {}; # depends on dotnetCorePackages.sdk_version
in
{
    home.packages = [
        pkgs-stable.libsForQt5.bismuth
        pkgs.kdePackages.fcitx5-with-addons
        pkgs.protonvpn-cli_2

        # Sys Management
        pkgs.gparted

        # productivity
        pkgs.zoom-us


        # Utilities
        pkgs.flameshot
        pkgs.simplescreenrecorder
        pkgs.yt-dlp
    ];
}