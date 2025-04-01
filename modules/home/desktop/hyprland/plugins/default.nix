{ inputs, options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

{
    imports = [
        ./hyprkool.nix
        ./virt-desktops.nix
    ];
}