{ pkgs, pkgs-stable, ... }:

{
    home.packages = with pkgs; [
        adwaita-icon-theme

        wlr-randr
        xorg.xrandr    # for XWayland windows
        nwg-look
        kdePackages.breeze-icons
        kdePackages.qtstyleplugin-kvantum

        swww           # wallpaper daemon
        hyprcursor

        wl-screenrec

        # clipboard managers (and associated tools) I'm trying
        wl-clipboard
        cliphist
        xdg-utils
        copyq
        clipman

        grim
        slurp
        swappy
        imagemagick

        pulseaudio
        killall # Restart processes
        pavucontrol # Audio panel
        sway-contrib.grimshot # Screenshots

        # notifications
        mako
        libnotify
    ];

    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        plugins = [ 
            pkgs.rofi-emoji-wayland
        ];
        font = "cascadia-code";
        location = "center";
    };
}