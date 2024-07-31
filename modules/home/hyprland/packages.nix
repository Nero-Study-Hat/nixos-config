{ pkgs, pkgs-stable, ... }:

{
    home.packages = with pkgs; [
        xorg.xrandr    # for XWayland windows
        nwg-look
        cascadia-code
        kdePackages.breeze-icons
        kdePackages.qtstyleplugin-kvantum
        catppuccin-kvantum
        adwaita-icon-theme

        swww           # wallpaper daemon
        rofi-wayland   # app launcher
        hyprcursor

        pulseaudio
        killall # Restart processes
        pavucontrol # Audio panel
        pulsemixer
        sway-contrib.grimshot # Screenshots

        # notifications
        mako
        libnotify

        (pkgs.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            })
        )
    ];
}