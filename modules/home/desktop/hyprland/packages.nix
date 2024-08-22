{ pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.home-modules.desktop.hyprland;
in
{
    options.home-modules.desktop.hyprland = with types; {
        enable = mkEnableOption "Whether to setup hyprland with associated packages and config on this desktop.";
    };

    config = mkIf cfg.enable {
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

            wl-clipboard
            xdg-utils
            copyq

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
    };
}