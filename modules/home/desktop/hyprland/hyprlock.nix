{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.desktop.hyprland.hyprlock;
in
{
    options.home-modules.desktop.hyprland.hyprlock = with types; {
        enable = mkEnableOption "Whether to setup hyprlock.";
        wallpaper = mkOption {
            type = path;
        };
        profile = mkOption {
            type = path;
        };
    };

    config = mkIf cfg.enable {
        wayland.windowManager.hyprland.settings = {
            bind = [
                "SUPER_L, l, exec, sleep 1 && hyprlock"
            ];
        };
        
        # source of hyprlock style: https://github.com/MrVivekRajan/Hyprlock-Styles/blob/main/Style-10/hyprlock.conf
        programs.hyprlock = {
            enable = true;
            package = pkgs.hyprlock;
            settings = {

                background = {
                    monitor = "";
                    path = cfg.wallpaper;

                    # blur
                    blur_passes = 2;
                    contrast = 0.8916;
                    brightness = 0.8172;
                    vibrancy = 0.1696;
                    vibrancy_darkness = 0.0;
                };

                general = {
                    #TODO: pam_module = pkgs.pam_u2f; 
                    no_fade_in = false;
                    grace = 0;
                    disable_loading_bar = false;
                    hide_cursor = true;
                };

                # Profie-Photo
                image = {
                    monitor = "";
                    path = cfg.profile;
                    border_size = 2;
                    border_color = "rgba(255, 255, 255, .65)";
                    size = 130;
                    rounding = -1;
                    rotate = 0;
                    reload_time = -1;
                    reload_cmd = "";
                    position = "0, 40";
                    halign = "center";
                    valign = "center";
                };

                # # USER-BOX
                shape = {
                    monitor = "";
                    size = "300, 60";
                    color = "rgba(255, 255, 255, .1)";
                    rounding = -1;
                    border_size = 0;
                    border_color = "rgba(255, 255, 255, 0)";
                    rotate = 0;
                    xray = false; # if true, make a "hole" in the background (rectangle of specified size, no rotation)

                    position = "0, -130";
                    halign = "center";
                    valign = "center";
                };

                # Day
                label = [ 
                    {
                        monitor = "";
                        text = ''cmd[update:1000] echo -e "$(date +"%A")"'';
                        color = "rgba(216, 222, 233, 0.70)";
                        font_size = 90;
                        font_family = "Cascadia Code";
                        position = "0, 350";
                        halign = "center";
                        valign = "center";
                    }

                    # Date-Month
                    {
                        monitor = "";
                        text = ''cmd[update:1000] echo -e "$(date +"%d %B")"'';
                        color = "rgba(216, 222, 233, 0.70)";
                        font_size = 40;
                        font_family = "Cascadia Code";
                        position = "0, 250";
                        halign = "center";
                        valign = "center";
                    }

                    # Time
                    {
                        monitor = "";
                        text = ''cmd[update:1000] echo "<span>$(date +"- %I:%M -")</span>"'';
                        color = "rgba(216, 222, 233, 0.70)";
                        font_size = 20;
                        font_family = "Cascadia Code";
                        position = "0, 190";
                        halign = "center";
                        valign = "center";
                    }
                    
                    # USER
                    {
                        monitor = "";
                        text = " $USER";
                        color = "rgba(216, 222, 233, 0.80)";
                        outline_thickness = 2;
                        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
                        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
                        dots_center = true;
                        font_size = 18;
                        font_family = "Cascadia Code";
                        position = "0, -130";
                        halign = "center";
                        valign = "center";
                    }
                ];

                # INPUT FIELD
                input-field = {
                    monitor = "";
                    size = "300, 60";
                    outline_thickness = 2;
                    dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
                    dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
                    dots_center = true;
                    outer_color = "rgba(255, 255, 255, 0)";
                    inner_color = "rgba(255, 255, 255, 0.1)";
                    font_color = "rgb(200, 200, 200)";
                    fade_on_empty = false;
                    font_family = "Cascadia Code";
                    placeholder_text = ''<i><span foreground="##ffffff99">🔒 Enter Pass</span></i>'';
                    hide_input = false;
                    position = "0, -210";
                    halign = "center";
                    valign = "center";
                };
            };
        };
    };
}