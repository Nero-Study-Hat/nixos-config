{ pkgs, pkgs-stable, rootPath, ... }:

let
    godot4-mono = pkgs.callPackage "${rootPath}/pkgs/godot4-mono" {}; # depends on dotnetCorePackages.sdk_version
in
{
    home.packages = [
        # utilities
        pkgs.protonvpn-cli_2
        pkgs.gparted
        pkgs.simplescreenrecorder
        pkgs.yt-dlp
    ];
}