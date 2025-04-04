{ options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    virtualDesktopSwitchExe = "${rootPath}/pkgs/virt-desktop-switcher/desktop-switcher";
    customVirtDesktopsModuleExe = "${rootPath}/pkgs/waybar-modules/virt-desktops";
    # customVirtDesktopsModuleExe = "${rootPath}/scripts/virt-desktops-waybar-module.sh";
    audioOuputSwitchScript = pkgs.pkgs.writeShellScriptBin "start" ''
        headphones="alsa_output.pci-0000_2f_00.4.analog-stereo"
        monitor="alsa_output.pci-0000_2d_00.1.hdmi-stereo-extra2"
        if [ $(pactl get-default-sink) == "$monitor" ]; then
            pactl set-default-sink "$headphones"
        elif [ $(pactl get-default-sink) == "$headphones" ]; then
            pactl set-default-sink "$monitor"
        fi
    '';
    cfg = config.home-modules.desktop.hyprland.waybar;
in
{
    options.home-modules.desktop.hyprland.waybar = with types; {
        enable = mkEnableOption "Whether to setup waybar.";
        c-modules = mkOption {
            type = listOf str;
            example = [ "custom/weather" ];
            default = [ "custom/weather" "custom/activity" "group/group-virt-desktops" ];
        };
        output-monitor = mkOption {
            type = str;
        };
        height = mkOption {
            type = int;
        };
    };

    config = mkIf cfg.enable {
        programs.waybar.enable = true;
        programs.waybar.package = (pkgs.waybar.overrideAttrs (oldAttrs: {
                                    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                                    })
                                );

        # configuration of the bar

        # doesn't allow comments
        # programs.waybar.settings = lib.importJSON "${dirPath}/config.jsonc";

        # use for getting inicode icons => https://www.nerdfonts.com/cheat-sheet

        # nixlang specific
        programs.waybar.settings."mainbar" = {
            "output" = cfg.output-monitor;
            "layer" = "top";
            "position" = "top";
            "height" = cfg.height;
            "spacing" = 10;

            "modules-left" = [ "group/group-power" "pulseaudio" "group/hardware" ];
            "modules-center" = cfg.c-modules;
            "modules-right" = [ "idle_inhibitor" "tray" "clock" ];

            "battery" = {
                "bat" = "BAT2";
                "interval" = 60;
                "states" = {
                    "warning" = 30;
                    "critical" = 15;
                };
                "format" = "{capacity}% {icon}";
                "format-icons" = ["" "" "" "" ""];
                "max-length" = 25;
            };

            "clock" = {
                "interval" = 60;
                "format" = "  {:%a %b %d  %H:%M}";
                "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                "format-alt" = "{:%Y-%m-%d}";
                "calendar" = {
                                "mode" =           "year";
                                "mode-mon-col" =   3;
                                "weeks-pos" =      "right";
                                "on-scroll" =      1;
                                "format" = {
                                    "months"    =  "<span color='#ffead3'><b>{}</b></span>";
                                    "days"      =  "<span color='#ecc6d9'><b>{}</b></span>";
                                    "weeks"     =  "<span color='#99ffdd'><b>W{}</b></span>";
                                    "weekdays"  =  "<span color='#ffcc66'><b>{}</b></span>";
                                    "today"     =  "<span color='#ff6699'><b><u>{}</u></b></span>";
                                };
                            };
                "actions" =  {
                    "on-click-right" = "mode";
                    "on-click-forward" = "tz_up";
                    "on-click-backward" = "tz_down";
                };
            };

            "tray" = {
                "icon-size"=  21;
                "spacing" = 10;
            };

            "group/hardware" = {
                "orientation" = "inherit";
                "modules" = [
                    "disk"
                    "cpu"
                    "memory"
                ];
            };

            "cpu" = {
                "interval" = 10;
                "format" = "{usage}% ";
                "max-length" = 10;
            };

            "memory" = {
                "interval" = 30;
                "format" = "{percentage}% ";
                "max-length" = 10;
                "tooltip-format" = "{used:0.1f}GiB used";
            };

            "disk" = {
                "interval" = 30;
                "format" = "{free} 🖴";
                "tooltip-format" = ''{used} used out of {total} on {path} ({percentage_used}%)'';
                "path" = "/";
            };

            "pulseaudio" = {
                "format" = "{volume}% {icon}";
                "format-muted" = "";
                "format-icons" = {
                    "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
                    "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
                    "headphone" = "";
                    "default" = ["" ""];
                };
                "scroll-step" = 1;
                "on-click" = "pavucontrol";
                "on-click-right" = ''${audioOuputSwitchScript}/bin/start'';
                "ignored-sinks" = ["Easy Effects Sink"];
            };

            "idle_inhibitor" = {
                "format"= "{icon}";
                "format-icons" = {
                    "activated" = "";
                    "deactivated" = "";
                };
            };

            "group/group-power" = {
                "orientation" = "inherit";
                "drawer" = {
                    "transition-duration" = 500;
                    "children-class" = "not-power";
                    "transition-left-to-right" = false;
                };
                "modules" = [
                    "custom/power" # First element is the "group leader" and won't ever be hidden
                    "custom/reboot"
                    "custom/lock"
                    "custom/quit"
                ];
            };
            "custom/quit" = {
                "format" = " 󰗼 ";
                "tooltip" = false;
                "on-click" = "hyprctl dispatch exit";
            };
            "custom/lock" = {
                "format" = " 󰍁 ";
                "tooltip" = false;
                "on-click" = "hyprlock";
            };
            "custom/reboot" = {
                "format" = " 󰜉 ";
                "tooltip" = false;
                "on-click" = "reboot";
            };
            "custom/power" = {
                "format" = "  ";
                "tooltip" = false;
                "on-click" = "shutdown now";
            };

            "custom/weather" = {
                "exec" = '' curl wttr.in/?format="%c%t" | sed "s/+//" '';
                "interval" = 600;
                "format" = "{}";
                "tooltip" = false; # TODO: setup AGS widget for this later
            };        
        };

        # CSS style of the bar
        # programs.waybar.style = {
        #     #
        # };
    };
}