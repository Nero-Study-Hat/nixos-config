{ pkgs, pkgs-stable, ... }:

{
    home.packages = with pkgs; [
        cascadia-code
        adwaita-icon-theme
        catppuccin-kvantum

        wlr-randr
        xorg.xrandr    # for XWayland windows
        nwg-look
        kdePackages.breeze-icons
        kdePackages.qtstyleplugin-kvantum

        swww           # wallpaper daemon
        rofi-wayland   # app launcher
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

        (pkgs.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            })
        )
    ];
}