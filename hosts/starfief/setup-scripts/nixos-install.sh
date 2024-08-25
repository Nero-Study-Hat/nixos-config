#!/usr/bin/env bash

# Get the repo.
echo -e $'\n**GETTING THE FLAKE REPO**\n'
export NIX_CONFIG="experimental-features = nix-command flakes"
export branch="main"
export proj_dir=".nixflake"
nix shell nixpkgs#git --command nix flake clone "github:Nero-Study-Hat/nixos-config/${branch}" --dest "/mnt/${proj_dir}"

# Install
echo $'\n**INSTALLING**\n'
nix shell nixpkgs#git --command nixos-install --impure --flake /mnt/${proj_dir}#stardom