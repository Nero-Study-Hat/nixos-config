{ inputs, lib, pkgs, rootPath, ... }:

let
    virtualDesktopSwitchScript = "${rootPath}/scripts/hyprland-desktops-switcher.sh";
in
{
    wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland.enable = true;
        systemd.enable = true;

        plugins = [
            # does not load because "/nix/store/8x6i3dndmna41ikshrp3jlgb5jw82wr6-hyprkool-0.7.0/lib/libhyprkool.so" DNE
            # hyprkool.packages.${pkgs.system}.default
            # hyprspace.packages.${pkgs.system}.Hyprspace # does not build (I did have the input)

            inputs.hyprland-virtual-desktops.packages.${pkgs.system}.virtual-desktops
        ];

        # hyprlang config
        extraConfig = lib.concatStrings [
            ''
                # animations {
                #     animation = workspaces, 1, 2, default, fade
                # }

                # # Switch activity
                # bind = $mainMod, TAB, exec, hyprkool next-activity -c

                # # Move active window to a different acitvity
                # bind = $mainMod CTRL, TAB, exec, hyprkool next-activity -c -w

                # # Relative workspace jumps
                # bind = CTRL ALT, left, exec, hyprkool move-left -c
                # bind = CTRL ALT, right, exec, hyprkool move-right -c
                # bind = CTRL ALT, down, exec, hyprkool move-down -c
                # bind = CTRL ALT, up, exec, hyprkool move-up -c

                # # Move active window to a workspace
                # bind = $mainMod CTRL, left, exec, hyprkool move-left -c -w
                # bind = $mainMod CTRL, right, exec, hyprkool move-right -c -w
                # bind = $mainMod CTRL, down, exec, hyprkool move-down -c -w
                # bind = $mainMod CTRL, up, exec, hyprkool move-up -c -w

                # # this only works if you have the hyprkool plugin
                # bind = $mainMod, a, exec, hyprkool toggle-overview

                # bind = SUPER, a, hyprexpo:expo, toggle # can be: toggle, off/disable or on/enable


                plugin {
                    # hyprkool {
                    #     overview {
                    #         hover_border_color = rgba(33ccffee)
                    #         focus_border_color = rgba(00ff99ee)
                    #         workspace_gap_size = 10
                    #     }
                    # }
                    virtual-desktops {
                        names = 1:main, 2:tech, 3:slack 
                        cycleworkspaces = 1
                        rememberlayout = size
                        notifyinit = 0
                        verbose_logging = 0
                    }
                }
            ''
        ];

        settings = {
            debug = {
                disable_logs = false;
            };

            "$terminal" = "cool-retro-term";
            "$mainMod" = "SUPER";
            "$menu" = "rofi -show drun -show-icons";
            "$screenshot" = ''grim -g "$(slurp)" - | swappy -f -'';

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
                    # "workspaces, 1, 2, default, fade"

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
                
                "CTRL ALT, up, exec, ${virtualDesktopSwitchScript} up focus"
                "CTRL ALT, down, exec, ${virtualDesktopSwitchScript} down focus"
                "CTRL ALT, right, exec, ${virtualDesktopSwitchScript} right focus"
                "CTRL ALT, left, exec, ${virtualDesktopSwitchScript} left focus"

                "CTRL $mainMod, up, exec, ${virtualDesktopSwitchScript} up window"
                "CTRL $mainMod, down, exec, ${virtualDesktopSwitchScript} down window"
                "CTRL $mainMod, right, exec, ${virtualDesktopSwitchScript} right window"
                "CTRL $mainMod, left, exec, ${virtualDesktopSwitchScript} left window"
            ];

            bindr = [
                "$mainMod, T, exec, $terminal"
                
                "alt, Q, killactive"
                "$mainMod, V, togglefloating"
                "$mainMod, S, togglespecialworkspace, magic"
                ",code:107, exec, $screenshot" # camera icon key on my keyboard
                "SUPER, SUPER_L, exec, rofi -show window"
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
                "hypridle"
            ];

            env = [
                "XCURSOR_SIZE,24"
                "HYPRCURSOR_SIZE,24"
                "QT_QPA_PLATFORM,wayland"
                "QT_QPA_PLATFORMTHEME,qt5ct"
                "QT_STYLE_OVERRIDE,kvantum"

                # for virtualizing
                "WLR_NO_HARDWARE_CURSORS,1"
                "WLR_RENDERER_ALLOW_SOFTWARE,1"

                "USE_WAYLAND_GRIM,true"
            ];
        };
    };
}