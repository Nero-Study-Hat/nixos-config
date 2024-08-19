{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

with lib;
# try the below
# with home-modules;
let
    cfg = config.roles.workstation;
in
{
    imports = [ 
        #TODO: conditional module for desktop
        ../../shell
    ];

    # have an option enable all groups by single option default and an option for each group
    # if the caller wants fine control within a group then they can use defaults for other groups
    # and specify themselves the settings they want for the group they want fine control over
    options.roles.workstation = with types; {
        enable-all-defaults = mkEnableOption "Enable all default shell packages and config.";
		desktop = lib.mkOption {
			type = lib.types.str;
			default = "kde";
			example = "hyprland";
			description = "The DE or WM with associated packages and config to setup.";
		};
        # groups below
        default-shell = mkEnableOption "Enable all default shell packages and config.";
    };

    config = mkMerge [
        ({
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

        ( mkIf (cfg.default-shell || cfg.default-shell)
        {
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
    ];

}