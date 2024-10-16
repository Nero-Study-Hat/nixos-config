{ options, config, lib, plasma-manager, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.home-modules.desktop.kde;
in
{
    options.home-modules.desktop.kde = with types; {
        enable = mkEnableOption "Enable kde desktop environment with associated packages and config.";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            pkgs-stable.libsForQt5.bismuth
            pkgs.kdePackages.fcitx5-with-addons
            pkgs.flameshot
            pkgs.kdePackages.yakuake
            pkgs.kdePackages.konsole
        ];

        programs.plasma = {
            enable = true;

            workspace = {
                clickItemTo = "select";
                lookAndFeel = "org.kde.breezedark.desktop";
                #   cursorTheme = "Bibata-Modern-Ice";
                #   iconTheme = "Papirus-Dark";
                #   wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
            };


            shortcuts = {
                kwin = {
                    #TODO: add shortcuts for moving windows
                    "Switch One Desktop to the Left" = "Ctrl+Alt+Left";
                    "Switch One Desktop to the Right" = "Ctrl+Alt+Right";
                    "Switch One Desktop Up" = "Ctrl+Alt+Up";
                    "Switch One Desktop Down" = "Ctrl+Alt+Down";
                    "ShowDesktopGrid" = "Meta+A";
                    "Window Close" = "Alt+Q";
                    "Window Operations Menu" = "Alt+R";
                    "toggle_spiral_layout" = "Alt+S";
                    # "next_layout" = "Ctrl+Shift+Meta+Right";
                    # "prev_layout" = "Ctrl+Shift+Meta+Left";
                };
            };


            configFile = {
                "kwinrc"."Desktops"."Number" = {
                    value = 4;
                    # Forces kde to not change this value (even through the settings app).
                    immutable = true;
                };
                "kwinrc"."Desktops"."Rows" = {
                    value = 2;
                    immutable = true;
                };
                "kwinrc"."Windows"."RollOverDesktops" = {
                    value = true;
                    immutable = true;
                };
                "kwinrc"."Plugins"."bismuthEnabled" = {
                    value = true;
                    immutable = true;
                };
            };
        };
    };
}