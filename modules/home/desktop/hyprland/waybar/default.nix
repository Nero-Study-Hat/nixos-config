{ inputs, options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

{
    imports = [
        ./main-modules.nix
        ./virt-desktop-modules.nix
    ];
}