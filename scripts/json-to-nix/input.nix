{
    "group/group-virt-desktops" = {
        "orientation" = "inherit";
        "drawer" = {
            "transition-duration" = 500;
            "children-class" = "not-power";
            "transition-left-to-right" = false;
        };
        "modules" = [
            "custom/virt-desktop-1" # First element is the "group leader" and won't ever be hidden
            "custom/virt-desktop-2"
            "custom/virt-desktop-3"
            "custom/virt-desktop-4"
        ];
    };
    "custom/virt-desktop-1" = {
        exec = "${customVirtDesktopsModuleScript}";
        "tooltip" = false;
        "on-click" = "hyprctl dispatch vdesk 1";
    };
    "custom/virt-desktop-2" = {
        exec = "${customVirtDesktopsModuleScript}";
        "tooltip" = false;
        "on-click" = "hyprctl dispatch vdesk 2";
    };
    "custom/virt-desktop-3" = {
        exec = "${customVirtDesktopsModuleScript}";
        "tooltip" = false;
        "on-click" = "hyprctl dispatch vdesk 3";
    };
    "custom/virt-desktop-4" = {
        exec = "${customVirtDesktopsModuleScript}";
        "tooltip" = false;
        "on-click" = "hyprctl dispatch vdesk 4";
    };
}