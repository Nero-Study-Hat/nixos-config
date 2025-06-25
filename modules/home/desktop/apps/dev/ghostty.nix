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
                # currently default catppuccin-mocha
                nero-theme = {
                    cursor-color = "f5e0dc";
                    foreground = "cdd6f4";
                    background = "1e1e2e";
                    palette = [
                        "0=#45475a"
                        "1=#f38ba8"
                        "2=#a6e3a1"
                        "3=#f9e2af"
                        "4=#89b4fa"
                        "5=#f5c2e7"
                        "6=#94e2d5"
                        "7=#bac2de"
                        "8=#585b70"
                        "9=#f38ba8"
                        "10=#a6e3a1"
                        "11=#f9e2af"
                        "12=#89b4fa"
                        "13=#f5c2e7"
                        "14=#94e2d5"
                        "15=#a6adc8"
                    ];
                    selection-background = "353749";
                    selection-foreground = "cdd6f4";
                };
            };

            settings = {
                # behavior
                auto-update = "off";
                quit-after-last-window-closed = "true";
                shell-integration-features = "true";

                # window
                initial-window = "true";
                resize-overlay = "never";
                background-opacity = "0.85";
                window-save-state = "always";
                window-step-resize = "false";
                background-blur-radius = "15";
                window-padding-balance = "true";
                confirm-close-surface = "false";

                # fonts
                theme = "Teerb";
                bold-is-bright = "true";
                font-style = "medium";
                font-size = "14";
                font-family = "Cascadia Code";

                # mouse
                mouse-scroll-multiplier = "2";
                mouse-hide-while-typing = "true";

            };
        };
    };
}