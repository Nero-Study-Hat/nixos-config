{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

with lib;
# try the below
# with home-modules;
let
    cfg = config.roles.workstation.home;
in
{
    imports = [ 
        #TODO: conditional module for desktop
        ../../home/shell
        ../../home/desktop/apps/basics
        ../../home/desktop/apps/creative
    ];

    # have an option enable all groups by single option default and an option for each group
    # if the caller wants fine control within a group then they can use defaults for other groups
    # and specify themselves the settings they want for the group they want fine control over
    options.roles.workstation.home = with types; {
        enable = mkEnableOption "Enable all packages and config.";
		desktop = lib.mkOption {
			type = lib.types.str;
			default = "kde";
			example = "hyprland";
			description = "The DE or WM with associated packages and config to setup.";
		};
        # groups below
        default-shell = mkOption {
            type = bool;
            default = true;
            description = "Enable all default shell packages and config.";
        };
        default-basics-apps = mkOption {
            type = bool;
            default = true;
            description = "Enable all default basic (near-fundamental) desktop apps and config.";
        };
        default-creative-apps = mkOption {
            type = bool;
            default = true;
            description = "Enable all default creative desktop apps and config.";
        };
        default-dev-apps = mkOption {
            type = bool;
            default = true;
            description = "Enable all default developer desktop apps and config.";
        };
    };

    # importing modules with a mkIf before the main mkMerge that holds everything
    # in the config causes infinite recusion so cfg.enable is used in side the main mkMerge
    config = mkMerge [
        ( mkIf (cfg.enable)
        {
            nixpkgs = {
                config.allowUnfree = true;
                config.permittedInsecurePackages = [ "electron-25.9.0" ];
            };

            home.packages = with pkgs; [
                cascadia-code
                source-code-pro
                noto-fonts
                noto-fonts-extra
                noto-fonts-cjk
                noto-fonts-cjk-sans
                noto-fonts-emoji
                font-awesome
            ];

            fonts.fontconfig.defaultFonts.emoji = ["Noto Color Emoji"];
        })

        (mkIf cfg.enable (mkMerge [
            ( mkIf (cfg.default-shell)
            {
                # home.packages = with pkgs; [ cowsay ];
                home-modules.shell = {
                    language.bash-enable = true;
                    direnv-enable = true;
                    git-enable = true;
                    tmux-enable = true;
                    htop-enable = true;
                    curl-enable = true;
                    wget-enable = true;
                    ncdu-enable = true;
                    file-enable = true;
                    neofetch-enable = true;
                    tldr-enable = true;
                };
            })

            ( mkIf (cfg.default-basics-apps)
            {
                home-modules.desktop.apps.basic = {
                    brave-browser-enable = true;
                    mullvad-browser-enable = true;
                    dolphin-enable = true;
                    vesktop-enable = true;
                    cool-retro-term-enable = true;
                };
            })

            ( mkIf (cfg.default-creative-apps)
            {
                home-modules.desktop.apps.creative = {
                    blender-enable = true;
                    krita-enable = true;
                    aseprite-enable = true;
                    davinci-resolve-enable = true;
                    pureref-enable = false;
                };
            })
            ( mkIf (cfg.default-dev-apps)
            {
                home-modules.desktop.apps.dev = {
                    editor = "vscode";
                    githup-desktop-enable = true;
                    godot4-mono-enable = true;
                };
            })
        ]))

    ];

}