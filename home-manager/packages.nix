{ pkgs, ... }:

{

    home.packages = with pkgs; [
        # Basics
        brave
        virtualbox
        libsForQt5.dolphin
        libsForQt5.bismuth

        # Development
        vscode
        git
        github-desktop

        # Game Dev
        godot_4

        # Sys Management
        bash
        gparted
        htop
        cool-retro-term
        curl
        wget

        # productivity
        morgen
        obsidian
        remnote

        # Secure Apps
        tor-browser
        protonvpn-cli_2
        # need to make yubico-authenticator nixpkg

        # Content Creation
        krita
        blender
        davinci-resolve
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