{
    programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = with pkgs.vscode-extensions; [
            bbenoist.Nix
            PKief.material-icon-theme
        ];
    };
}