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
                "SUPER, Q, exec, ${virtualDesktopSwitchExe} focus activityRofi"
                
                "CTRL ALT, up, exec, ${virtualDesktopSwitchExe} focus up"
                "CTRL ALT, down, exec, ${virtualDesktopSwitchExe} focus down"
                "CTRL ALT, right, exec, ${virtualDesktopSwitchExe} focus right"
                "CTRL ALT, left, exec, ${virtualDesktopSwitchExe} focus left"

                "CTRL $mainMod, up, exec, ${virtualDesktopSwitchExe} window up"
                "CTRL $mainMod, down, exec, ${virtualDesktopSwitchExe} window down"
                "CTRL $mainMod, right, exec, ${virtualDesktopSwitchExe} window right"
                "CTRL $mainMod, left, exec, ${virtualDesktopSwitchExe} window left"
            ];
        };

    };
}