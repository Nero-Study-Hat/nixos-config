{ pkgs, ... }:

imports = [ ./programs/bash.nix
            ./programs/git.nix
        ];

home.packages = with pkgs; [
    # Basics
    brave
    libsForQt5.dolphin

    # Development
    vscode
    virtualbox
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
    pureref

    # Utilities
    neofetch
    tldr
    flameshot
    yt-dlp

    # Media
    freetube

    # Video Creation
    davinci-resolve
    audacity

];