{ inputs, options, config, lib, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

with lib;
let
    cfg = config.roles.workstation.home;
in
{
    imports = [ ../../home ];

    # have an option enable all groups by single option default and an option for each group
    # if the caller wants fine control within a group then they can use defaults for other groups
    # and specify themselves the settings they want for the group they want fine control over
    options.roles.workstation.home = with types; {
        enable = mkEnableOption "Enable all packages and config.";
        user = mkOption {
            type = str;
            default = "nero";
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
        default-utility-apps = mkOption {
            type = bool;
            default = true;
            description = "Enable all default desktop utilities and config.";
        };
        default-gaming = mkOption {
            type = bool;
            default = true;
            description = "Enable all default gaming packages and config.";
        };
    };

    # importing modules with a mkIf before the main mkMerge that holds everything
    # in the config causes infinite recusion so cfg.enable is used in side the main mkMerge
    #TODO: create assertion caller input to build successfully
    config = mkMerge [
        ( mkIf (cfg.enable)
        {
            home.username = cfg.user;
            home.homeDirectory = "/home/${cfg.user}";

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

            programs.home-manager.enable = true;
            home.stateVersion = "24.05";
        })

        (mkIf cfg.enable (mkMerge [
            ( mkIf (cfg.default-shell)
            {
                # home.packages = with pkgs; [ cowsay ];
                home-modules.shell = {
                    language.bash-enable = true;
                    ssh-client.enable = true;
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
                    morgen-enable = true;
                    zoom-enable = false;
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
                    remnote-enable = true;
                    obsidian-enable = true;
                };
            })
            ( mkIf (cfg.default-dev-apps)
            {
                home-modules.desktop.apps.dev = {
                    editor = "vscode";
                    githup-desktop-enable = true;
                    godot4-mono-enable = false; # currently doesn't work
                };
            })
            ( mkIf (cfg.default-utility-apps)
            {
                home-modules.desktop.apps.utility = {
                    protonvpn-enable = true;
                    gparted-enable = false;
                    simplescreenrecorder-enable = true;
                    yt-dlp-enable = true;
                    yubico-authenticator-enable = true;
                };
            })
            ( mkIf (cfg.default-gaming)
            {
                home-modules.desktop.gaming = {
                    steam-enable = true;
                    #TODO: bottles
                    #TODO: wine
                    #TODO: lutris
                };
            })
        ]))

    ];

}