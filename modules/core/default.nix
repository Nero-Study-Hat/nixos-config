{ inputs, lib, config, options, pkgs, ... }:

{
    imports = [
        ../../core/virtualization.nix
        ../../core/desktop.nix
        ../../core/yubikey.nix
    ];
}