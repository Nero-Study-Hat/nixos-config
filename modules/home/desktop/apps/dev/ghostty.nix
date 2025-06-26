{ options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.dev;
in
{
    options.home-modules.desktop.apps.dev = with types; {
        ghostty-enable = mkEnableOption "Enable ghostty-term.";
        ghostty-pkg = mkOption {
            type = package;
            default = pkgs.ghostty;
        };
    };

    config = mkIf cfg.ghostty-enable {
        programs.ghostty = {
            enable = true;
            package = cfg.ghostty-pkg;
            enableZshIntegration = true;

            # custom theming
            themes = {
                nero-theme = {
                    cursor-color = "#7e57c2";
                    background = "011628";
                    foreground = "d6deeb";
                    palette = [
                        "0=#011628"
                        "1=#EF5350"
                        "2=#22DA6E"
                        "3=#ADDB67"
                        "4=#82AAFF"
                        "5=#C792EA"
                        "6=#21C7A8"
                        "7=#FFFFFF"
                        "8=#575656"
                        "9=#EF5350"
                        "10=#22DA6E"
                        "11=#FFEB95"
                        "12=#82AAFF"
                        "13=#C792EA"
                        "14=#7FDBCA"
                        "15=#FFFFFF"
                    ];
                    selection-background = "5f7e97";
                    selection-foreground = "dee4ee";
                };
            };

            settings = {
                # behavior
                auto-update = "off";
                shell-integration-features = "no-cursor";
                confirm-close-surface = "false";
                window-save-state = "always";
                quit-after-last-window-closed = "true";
                initial-window = "true";
                

                # window
                background-opacity = "0.75";
                background-blur-radius = "15";
                window-padding-x = "10";
                window-padding-y = "10";
                window-padding-balance = "true";
                gtk-wide-tabs = "false";

                # fonts
                theme = "nero-theme";
                bold-is-bright = "true";
                font-style = "medium";
                font-size = "15";
                font-family = "Cascadia Code";
                font-feature = "+liga,+calt";

                # mouse
                cursor-color = "#4dd6cc";
                cursor-style = "bar";
                cursor-style-blink = "false";
                mouse-scroll-multiplier = "2";
                mouse-hide-while-typing = "true";

                # shortcuts
                keybind = [
                    "ctrl+`>left=goto_split:left"
                    "ctrl+`>down=goto_split:down"
                    "ctrl+`>up=goto_split:up"
                    "ctrl+`>right=goto_split:right"

                    "ctrl+a>left=new_split:left"
                    "ctrl+a>down=new_split:down"
                    "ctrl+a>up=new_split:up"
                    "ctrl+a>right=new_split:right"
                    "ctrl+a>enter=toggle_split_zoom"
                    "ctrl+a>backspace=close_surface"
                ];

            };
        };
    };
}