{ pkgs, ... }:

home.packages = with pkgs; [
    # Basics
    brave
    libsForQt5.dolphin

    # Development
    vscode
    git
    github-desktop
    virtualbox

    # Sys Management
    gparted

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

    # Aesthetic
    neofetch

    # Misc
    tldr
    flameshot
    yt-dlp

    # Media Platforms
    steam
    freetube

    # Video Creation
    davinci-resolve
    audacity

];
