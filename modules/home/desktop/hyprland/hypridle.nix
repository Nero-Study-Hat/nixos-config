{ options, config, lib, pkgs, ... }:

# TODO: asset hyprlock module is enabled

with lib;
let
    cfg = config.home-modules.desktop.hyprland.hypridle;
in
{
    options.home-modules.desktop.hyprland.hypridle = with types; {
        enable = mkEnableOption "Whether to setup hypridle.";
    };

    config = mkIf cfg.enable {
        services.hypridle = {
            enable = true;
            package = pkgs.hypridle;
            settings = {
                general = {
                    lock_cmd = "pidof hyprlock || hyprlock";
                    before_sleep_cmd = "loginctl lock-session";
                    after_sleep_cmd = "hyprctl dispatch dpms on";
                };

                # brightness to 0
                listener = [
                    {
                        timeout = 150;   # 2.5 min
                        on-timeout = "brightnessctl -s set 10";
                        on-resume = "brightnessctl -r";
                    }

                    # turn off keyboard backlight
                    {
                        timeout = 150;   # 2.5 min
                        on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
                        on-resume = "brightnessctl -rd rgb:kbd_backlight";
                    }

                    # lock session
                    {
                        timeout = 300;  # 5 min
                        on-timeout = "loginctl lock-session";
                    }

                    # turn screen off from lock screen
                    {
                        timeout = 330;                              # 5.5min
                        on-timeout = "hyprctl dispatch dpms off";   # screen off when timeout has passed
                        on-resume = "hyprctl dispatch dpms on";     # screen on when activity is detected after timeout has fired.
                    }

                    # suspend device
                    {
                        timeout = 420; # 7 min
                        on-timeout = "systemctl suspend";
                    }
                ];
            };
        };
    };
}