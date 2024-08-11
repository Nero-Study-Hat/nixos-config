{ inputs, lib, pkgs, rootPath, ... }:

let
    virtualDesktopSwitchScript = "${rootPath}/scripts/hyprland-workspaces/desktops-switcher.sh";
in
{
    wayland.windowManager.hyprland = {
        plugins = [
            inputs.hyprland-virtual-desktops.packages.${pkgs.system}.virtual-desktops
        ];

        # hyprlang config
        extraConfig = lib.concatStrings [
            ''
                plugin {
                    virtual-desktops {
                        cycleworkspaces = 1
                        rememberlayout = size
                        notifyinit = 0
                        verbose_logging = 0
                    }
                }
            ''
        ];

        settings = {
            bind = [
                "CTRL ALT, up, exec, ${virtualDesktopSwitchScript} up focus"
                "CTRL ALT, down, exec, ${virtualDesktopSwitchScript} down focus"
                "CTRL ALT, right, exec, ${virtualDesktopSwitchScript} right focus"
                "CTRL ALT, left, exec, ${virtualDesktopSwitchScript} left focus"

                "CTRL $mainMod, up, exec, ${virtualDesktopSwitchScript} up window"
                "CTRL $mainMod, down, exec, ${virtualDesktopSwitchScript} down window"
                "CTRL $mainMod, right, exec, ${virtualDesktopSwitchScript} right window"
                "CTRL $mainMod, left, exec, ${virtualDesktopSwitchScript} left window"
            ];
        };

    };
}