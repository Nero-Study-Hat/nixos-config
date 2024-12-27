#!/usr/bin/env bash

NIX_CONFIG="experimental-features = nix-command flakes"
branch="14-modularize-config"
proj_dir=".nixflake"
TMPDIR="/mnt/${proj_dir}/tmp"

echo "branch: ${branch}"
read -p $'Enter (yes/y) if you are happy with the above branch: ' branch_choice

if [[ "$branch_choice" != "yes" && "$branch_choice" != "y" ]]; then
    read -p $'Enter the name of the desired branch: ' branch_choice
fi

branch="$branch_choice"

echo -e $'\n**Installing System**\n'
github_key_target="/mnt/etc/ssh/id_ed25519_github"

mkdir -p "/mnt/etc/ssh"
eval `ssh-agent`;ssh-add "$github_key_target"

cd "/mnt"

echo -e $'\n**GETTING THE FLAKE REPO**\n'
mkdir -p "$TMPDIR"
nix shell nixpkgs#git --command nix flake clone "github:Nero-Study-Hat/nixos-config/${branch}" --dest "/mnt/${proj_dir}"

# Install
echo $'\n**INSTALLING**\n'
nix shell nixpkgs#git --command nixos-install --impure --flake "/mnt/${proj_dir}#starfief"