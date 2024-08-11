{ pkgs, ... }:

{
    programs.vscode = {
        enable = true;
        package = pkgs.vscode;
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
}