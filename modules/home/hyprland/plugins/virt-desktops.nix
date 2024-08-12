{ inputs, lib, pkgs, rootPath, ... }:

let
    virtualDesktopSwitchExe = "${rootPath}/pkgs/virt-desktop-switcher/desktop-switcher";
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
                "CTRL ALT, up, exec, ${virtualDesktopSwitchExe} up focus"
                "CTRL ALT, down, exec, ${virtualDesktopSwitchExe} down focus"
                "CTRL ALT, right, exec, ${virtualDesktopSwitchExe} right focus"
                "CTRL ALT, left, exec, ${virtualDesktopSwitchExe} left focus"

                "CTRL $mainMod, up, exec, ${virtualDesktopSwitchExe} up window"
                "CTRL $mainMod, down, exec, ${virtualDesktopSwitchExe} down window"
                "CTRL $mainMod, right, exec, ${virtualDesktopSwitchExe} right window"
                "CTRL $mainMod, left, exec, ${virtualDesktopSwitchExe} left window"
            ];
        };

    };
}