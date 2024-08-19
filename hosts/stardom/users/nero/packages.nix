{ pkgs, pkgs-stable, rootPath, ... }:

let
    godot4-mono = pkgs.callPackage "${rootPath}/pkgs/godot4-mono" {}; # depends on dotnetCorePackages.sdk_version
in
{
    home.packages = [
        pkgs-stable.libsForQt5.bismuth
        pkgs.kdePackages.fcitx5-with-addons
        pkgs.protonvpn-cli_2

        # Development
        pkgs.vscode
        pkgs.github-desktop

        # # Game Dev
        pkgs.godot_4
        # godot4-mono

        # Sys Management
        pkgs.gparted
        pkgs.cool-retro-term

        # productivitya
        pkgs.morgen
        pkgs.obsidian
        pkgs.remnote
        pkgs.zoom-us


        # Content Creation
        pkgs.blender-hip
        # pkgs-stable.davinci-resolve
        pkgs.krita
        pkgs.aseprite
        pkgs.pureref  # currently requires manual setup, does not work on hyprland


        # Utilities
        pkgs.flameshot
        pkgs.simplescreenrecorder
        pkgs.yt-dlp
    ];
}