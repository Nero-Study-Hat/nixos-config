{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ ../../../../modules/roles/workstation/home-modules.nix ];

    home.keyboard.layout = "us";

    roles.workstation.home = {
        enable = true;
        user = "bo";
        kde = true;
        default-gaming = true;

        hyprland = false;
        default-shell = false;
        default-creative-apps = false;
        default-dev-apps = false;
        default-utility-apps = false;
    };

    home-modules.shell.language.bash-enable = true;
}