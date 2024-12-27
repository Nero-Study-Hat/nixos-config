#!/usr/bin/env bash

export NIX_CONFIG="experimental-features = nix-command flakes"
export branch="14-modularize-config"
export proj_dir=".nixflake"
export TMPDIR="/mnt/${proj_dir}/tmp"

echo "branch: ${branch}"
read -p $'Enter (yes/y) if you are happy with the above branch: ' branch_choice

if [[ "$branch_choice" != "yes" && "$branch_choice" != "y" ]]; then
    read -p $'Enter the name of the desired branch: ' branch_choice
    branch="$branch_choice"
fi


echo -e $'\n**GETTING THE FLAKE REPO**\n'
nix shell nixpkgs#git --command nix flake clone "github:Nero-Study-Hat/nixos-config/${branch}" --dest "/mnt/${proj_dir}"

echo -e $'\n**Making TMPDIR**\n'
mkdir -p "$TMPDIR"

# Install
echo $'\n**INSTALLING**\n'
nix shell nixpkgs#git --command nixos-install --impure --flake "/mnt/${proj_dir}#starfief"