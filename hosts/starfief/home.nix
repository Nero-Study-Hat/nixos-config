{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ ../../modules/roles/workstation/home-modules.nix ];

    home.keyboard.layout = "us";

    roles.workstation.home = {
        enable = true;
        user = "alaric";
    };
}