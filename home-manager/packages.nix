{ pkgs, pkgs-stable, rootPath, ... }:

let
    # godot4-mono = pkgs.callPackage /home/nero/.nixflake/pkgs/godot4-mono {}; # starts building before hitting an error later in process
    godot4-mono = pkgs.callPackage "${rootPath}/pkgs/godot4-mono" {};
in
{
    home.packages = [
        # Basics
        pkgs.brave
        pkgs.libsForQt5.dolphin
        pkgs.libsForQt5.bismuth

        # Development
        pkgs.vscode
        pkgs.git
        pkgs.github-desktop

        # Game Dev
        # pkgs.godot_4
        godot4-mono

        # Sys Management
        pkgs.bash
        pkgs.gparted
        pkgs.htop
        pkgs.cool-retro-term
        pkgs.curl
        pkgs.wget

        # productivity
        pkgs.morgen
        pkgs.obsidian
        pkgs.remnote

        # Secure Apps
        pkgs.tor-browser
        pkgs.protonvpn-cli_2
        # need to make yubico-authenticator nixpkg

        # Content Creation
        pkgs.krita
        pkgs.blender
        pkgs-stable.davinci-resolve
        # pureref  # currently requires manual setup


        # Utilities
        pkgs.neofetch
        pkgs.tldr
        pkgs.flameshot
        pkgs.yt-dlp

        # Media
        pkgs.freetube

        # Fun
        pkgs.cmatrix
        pkgs.steam-tui
        pkgs.steamcmd
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