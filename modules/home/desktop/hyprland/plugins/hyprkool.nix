{ inputs, options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    handleHyprkoolTomlScript = "${rootPath}/scripts/handleHyprkoolToml.sh";
    virtualDesktopSwitchExe = "${rootPath}/pkgs/virt-desktop-switcher/desktop-switcher";
    cfg = config.home-modules.desktop.hyprland.hyprkool;
in
{
    options.home-modules.desktop.hyprland.hyprkool = with types; {
        enable = mkEnableOption "Whether to setup hyprkool plugin with associated packages and config.";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ inputs.hyprkool.packages."${system}".default ];
        wayland.windowManager.hyprland = {
            plugins = [
                inputs.hyprkool.packages.${pkgs.system}.hyprkool-plugin
            ];

            settings = {
                exec-once = [
                    ''${handleHyprkoolTomlScript}/bin/start "${rootPath}"''
                    "hyprkool daemon -m"
                ];
            };

            # hyprlang config
            extraConfig = lib.concatStrings [
                ''
                    animations {
                        animation = workspaces, 1, 2, default, fade
                    }

                    # Switch activity
                    bind = $mainMod, TAB, exec, hyprkool next-activity -c

                    # Move active window to a different acitvity
                    bind = $mainMod CTRL, TAB, exec, hyprkool next-activity -c -w

                    # Relative workspace jumps
                    bind = CTRL ALT, left, exec, hyprkool move-left -c
                    bind = CTRL ALT, right, exec, hyprkool move-right -c
                    bind = CTRL ALT, down, exec, hyprkool move-down -c
                    bind = CTRL ALT, up, exec, hyprkool move-up -c

                    # Move active window to a workspace
                    bind = $mainMod CTRL, left, exec, hyprkool move-left -c -w
                    bind = $mainMod CTRL, right, exec, hyprkool move-right -c -w
                    bind = $mainMod CTRL, down, exec, hyprkool move-down -c -w
                    bind = $mainMod CTRL, up, exec, hyprkool move-up -c -w

                    # this only works if you have the hyprkool plugin
                    bind = $mainMod, a, exec, hyprkool toggle-overview

                    plugin {
                        hyprkool {
                            overview {
                                hover_border_color = rgba(33ccffee)
                                focus_border_color = rgba(00ff99ee)
                                workspace_gap_size = 10
                            }
                        }
                    }
                ''
            ];
        };
    };

}