{ pkgs, ... }:

{

    home.packages = with pkgs; [
        # Basics
        brave
        libsForQt5.dolphin
        libsForQt5.bismuth

        # Development
        vscode
        virtualbox
        git
        github-desktop
        bash
        cool-retro-term
        tmux

        # Sys Management
        gparted
        htop

        # Notes
        obsidian
        remnote

        # Secure Apps
        tor-browser
        protonvpn-cli_2
        # need to make yubico-authenticator nixpkg

        # Art
        krita
        blender
        # pureref  # currently requires manual setup

        # Utilities
        neofetch
        tldr
        flameshot
        yt-dlp

        # Media
        freetube

        # Fun
        cmatrix
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