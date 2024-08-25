{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ ../../../../modules/roles/minimal-workstation/home-modules.nix ];

    home.keyboard.layout = "us";

    roles.workstation.home = {
        enable = true;
        user = "nero";
    };

    home-modules.desktop.apps.utility.yubico-authenticator-enable = true;
}