{ lib, pkgs, inputs, rootPath, ... }:

{
    wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland.enable = true;

        # plugins = [
        #     inputs.hyprkool.packages.${pkgs.system}.hyprkool-plugin
        # ];

        extraConfig = lib.concatStrings [
            ''
                # hyprlang config
            ''
        ];

        settings = {
            "$terminal" = "cool-retro-term";
            "$mainMod" = "SUPER";
            "$menu" = "rofi -show drun -show-icons";

            monitor = [
                "DP-2, 3440x1440@100, auto-left, 1"
                "HDMI-A-1, 1680x1050@60, 0x0, 1, transform, 1"
            ];

            xwayland = {
                force_zero_scaling = true;
            };

            general = { 
                gaps_in = 5;
                gaps_out = 20;
                border_size = 2;
                "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";
                layout = "dwindle";
                allow_tearing = true;
            };

            decoration = {
                rounding = 15;

                # Change transparency of focused and unfocused windows
                active_opacity = 1.0;
                inactive_opacity = 0.95;
                fullscreen_opacity = 1.0;

                drop_shadow = true;
                shadow_range = 4;
                shadow_render_power = 3;
                "col.shadow" = "rgba(1a1a1aee)";

                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;
                    vibrancy = 0.1696;
                };
            };

            misc = { 
                force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
                disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
            };

            animations = {
                enabled = true;
                bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
                animation = [
                    "windows, 1, 7, myBezier"
                    "windowsOut, 1, 7, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default"
                ];
            };

            master = {
                new_status = true;
            };

            dwindle = {
                pseudotile = true;
                preserve_split = true;
            };

            bind = [
                "ALT, SPACE, exec, $menu"
            ];

            bindr = [
                "$mainMod, T, exec, $terminal"
                
                "alt, Q, killactive"
                "$mainMod, V, togglefloating"
                "$mainMod, S, togglespecialworkspace, magic"
            ];

            bindm = [
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
                "$mainMod ALT, mouse:272, resizewindow"
            ];

            device = {
                name = "epic-mouse-v1";
                sensitivity = 0.75;
            };

            input = {
                kb_layout = "us";
                follow_mouse = 1;
                sensitivity = 0;
            };

            windowrulev2 = [
                "suppressevent maximize, class:.*"
            ];

            exec-once = [
                "waybar & swww"
            ];

            env = [
                "XCURSOR_SIZE,24"
                "HYPRCURSOR_SIZE,24"
            ];
        };
    };
}