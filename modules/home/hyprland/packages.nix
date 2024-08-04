{ pkgs, pkgs-stable, ... }:

{
    home.packages = with pkgs; [
        adwaita-icon-theme
        catppuccin-kvantum

        wlr-randr
        xorg.xrandr    # for XWayland windows
        nwg-look
        kdePackages.breeze-icons
        kdePackages.qtstyleplugin-kvantum

        swww           # wallpaper daemon
        hyprcursor

        wl-screenrec
        wl-clipboard

        grim
        slurp
        swappy

        pulseaudio
        killall # Restart processes
        pavucontrol # Audio panel
        pulsemixer
        sway-contrib.grimshot # Screenshots

        # notifications
        mako
        libnotify
    ];

    nixpkgs.overlays = [(final: prev: {
        rofi-emoji = prev.rofi-emoji.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })];

    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        plugins = [ pkgs.rofi-emoji ];
        font = "cascadia-code";
    };
}