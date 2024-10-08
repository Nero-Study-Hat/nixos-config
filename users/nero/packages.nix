{ pkgs, pkgs-stable, rootPath, ... }:

let
    godot4-mono = pkgs.callPackage "${rootPath}/pkgs/godot4-mono" {}; # depends on dotnetCorePackages.sdk_version
in
{
    home.packages = [
        # Basics
        pkgs.brave
        pkgs.mullvad-browser
        pkgs.vesktop
        pkgs.libsForQt5.dolphin
        pkgs-stable.libsForQt5.bismuth
        pkgs.kdePackages.fcitx5-with-addons
        pkgs.protonvpn-cli_2

        # Development
        pkgs.vscode
        pkgs.git
        pkgs.github-desktop

        # # Game Dev
        pkgs.godot_4
        # godot4-mono

        # Sys Management
        pkgs.gparted
        pkgs.htop
        pkgs.cool-retro-term
        pkgs.curl
        pkgs.wget
        pkgs.ncdu
        pkgs.file

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
        pkgs.neofetch
        pkgs.tldr
        pkgs.flameshot
        pkgs.simplescreenrecorder
        pkgs.yt-dlp
    ];

    programs.tmux = {
        enable = true;
        package = pkgs.tmux;
    };

    programs.htop = {
        enable = true;
        package = pkgs.htop;
    };
}