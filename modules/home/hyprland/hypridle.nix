{ lib, pkgs, ... }:

{
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
            listener = {
                timeout = 150;   # 2.5 min
                on-timeout = "brightnessctl -s set 10";
                on-resume = "brightnessctl -r";
            };

            # turn off keyboard backlight
            listener = {
                timeout = 150;   # 2.5 min
                on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
                on-resume = "brightnessctl -rd rgb:kbd_backlight";
            };

            # lock session
            listener = {
                timeout = 300;  # 5 min
                on-timeout = "loginctl lock-session";
            };

            # turn screen off from lock screen
            listener = {
                timeout = 330;                              # 5.5min
                on-timeout = "hyprctl dispatch dpms off";   # screen off when timeout has passed
                on-resume = "hyprctl dispatch dpms on";     # screen on when activity is detected after timeout has fired.
            };

            # suspend device
            listener = {
                timeout = 1200; # 20 min
                on-timeout = "systemctl suspend";
            };
        };
    };
}