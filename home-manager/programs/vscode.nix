{ pkgs, ... }:

{
    programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        # ext ids must be all lowercase
        extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            pkief.material-icon-theme
        ];
    };
}