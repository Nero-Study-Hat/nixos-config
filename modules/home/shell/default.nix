{ inputs, lib, pkgs, pkgs-stable, rootPath, ... }:

{
    imports = [
        ./bash.nix
        ./git.nix
        ./packages.nix
    ];
}