{ lib, pkgs, rootPath, ... }:

let
    virtualDesktopSwitchExe = "${rootPath}/pkgs/virt-desktop-switcher/desktop-switcher";
    customVirtDesktopsModuleExe = "${rootPath}/pkgs/waybar-modules/virt-desktops";
    customActivityModuleExe = "${rootPath}/pkgs/waybar-modules/activity";
in
{
    # for right of modules center: [ "custom/activity" "group/group-virt-desktops" ]
    programs.waybar.settings."mainbar" = {
        "custom/activity" = {
            "format" = "{}";
            "return-type" = "json";
            "tooltip" = false;
            "on-click" = "${virtualDesktopSwitchExe} focus activityRofi";
            "exec" = "${customActivityModuleExe}";
        };

        "group/group-virt-desktops" = {
            "orientation" = "inherit";
            "modules" = [
                "custom/virt-desktop-1" # First element is the "group leader" and won't ever be hidden
                "custom/virt-desktop-2"
                "custom/virt-desktop-3"
                "custom/virt-desktop-4"
            ];
        };

        "custom/virt-desktop-1" = {
            "format" = "{}";
            "return-type" = "json";
            "tooltip" = false;
            "on-click" = "${virtualDesktopSwitchExe} 1";
            "exec" = ''${customVirtDesktopsModuleExe} 1'';
        };
        "custom/virt-desktop-2" = {
            "return-type" = "json";
            "format" = "{}";
            "tooltip" = false;
            "on-click" = "${virtualDesktopSwitchExe} 2";
            "exec" = ''${customVirtDesktopsModuleExe} 2'';
        };
        "custom/virt-desktop-3" = {
            "format" = "{}";
            "return-type" = "json";
            "tooltip" = false;
            "on-click" = "${virtualDesktopSwitchExe} 3";
            "exec" = ''${customVirtDesktopsModuleExe} 3'';
        };
        "custom/virt-desktop-4" = {
            "format" = "{}";
            "return-type" = "json";
            "tooltip" = false;
            "on-click" = "${virtualDesktopSwitchExe} 4";
            "exec" = ''${customVirtDesktopsModuleExe} 4'';
        };
    };
}