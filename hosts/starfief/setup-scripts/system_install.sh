#!/usr/bin/env bash

export NIX_CONFIG="experimental-features = nix-command flakes"
export branch="14-modularize-config"
export proj_dir=".nixflake"
export TMPDIR="/mnt/${proj_dir}/tmp"

function git_flake_download () {
    echo "branch: ${branch}"
    read -p $'Enter (yes/n) if you are happy with the above branch: ' branch_choice
    if [[ "$branch_choice" != "yes" && "$branch_choice" != "n" ]]; then
        read -p $'Enter the name of the desired branch: ' branch_choice
        branch="$branch_choice"
    fi
    echo -e $'\n**GETTING THE FLAKE REPO**\n'
    nix shell nixpkgs#git --command nix flake clone "github:Nero-Study-Hat/nixos-config/${branch}" --dest "/mnt/${proj_dir}"
}

read -p $'Download flake from git source (yes/n): ' download_check

if [[ "$download_check" == "yes" || "$download_check" == "y" ]]; then
    git_flake_download
fi

echo -e $'**Preparing Files & Directories**'
mkdir -p "/mnt/${proj_dir}/sops-nix"
mv "/mnt/secrets_key" "/mnt/${proj_dir}/sops-nix/secrets_key"
mkdir -p "$TMPDIR"
cd "/mnt/${proj_dir}" && nix shell nixpkgs#git --command git add "sops-nix/secrets_key"
cd "/mnt"

# Install
echo $'\n**INSTALLING**\n'
nix shell nixpkgs#git --command nixos-install --impure --flake "/mnt/${proj_dir}#starfief"

cd "/mnt/${proj_dir}"
rm -r "sops-nix"