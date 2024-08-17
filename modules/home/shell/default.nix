{ inputs, lib, pkgs, pkgs-stable, rootPath, ... }:

{
    imports = [
        ./bash.nix
        ./git.nix
        ./packages.nix
        ./test.nix
    ];

    home-modules.shell = {
        defaults-enable = true;
        extra-enable = true;
    }
}