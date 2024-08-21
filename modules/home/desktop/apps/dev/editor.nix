{ options, config, lib, pkgs, pkgs-stable, ... }:

### NOTE: default user shell is set by nixos-configuration, not home-manager

with lib;
let
    cfg = config.home-modules.desktop.apps.dev;
    chosen-pkgs = if (cfg.pkgs-stable == true) then pkgs-stable else pkgs;
in
{
    options.home-modules.desktop.apps.dev = with types; {
		editor = lib.mkOption {
			type = lib.types.str;
			default = "vscode";
			example = "nvim";
			description = "The text editor with associated packages and config to setup.";
		};
        pkgs-stable = mkEnableOption "Whether to us nixpkgs-stable as opposed to unstable.";
    };

    config = mkMerge [
        ( mkIf (cfg.editor == "vscode")
        {
            programs.vscode = {
                enable = true;
                package = chosen-pkgs.vscode;
                enableUpdateCheck = false;
                enableExtensionUpdateCheck = false;

                # ext ids must be all lowercase
                extensions = with pkgs.vscode-extensions; [
                    pkief.material-icon-theme
                    bbenoist.nix
                    ms-vscode.cpptools-extension-pack
                ];

                userSettings = {
                    "extensions.autoCheckUpdates" = false;
                    "update.mode" = "none";
                    "editor.fontSize" = 15;
                    "editor.fontFamily" = "Cascadia Code";
                    "editor.codeLensFontFamily" = "Cascadia Code";
                    "editor.fontLigatures" = true;
                    "editor.minimap.enabled" = false;
                    "workbench.iconTheme" = "material-icon-theme";
                };
            };
        })
        # ( mkIf (cfg.editor == "nvim")
        # {
        #     ## config
        # })
    ];
}