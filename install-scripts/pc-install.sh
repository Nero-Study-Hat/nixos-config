#!/bin/bash

# Partition Handling
echo -e $'**PARTITION HANDLING**\n'
mount -L nixos /mnt
mkdir -p /mnt/boot/efi
mount -L NIXOS_EFI /mnt/boot/efi
swapon /dev/nvme1n1p7

# Get the repo.
echo -e $'\n**GETTING THE FLAKE REPO**\n'
export NIX_CONFIG="experimental-features = nix-command flakes"
export branch="feat/7-get-my-nixos-project-setup-on-my-pc"
export proj_dir=".n"
nix shell nixpkgs#git --command nix flake clone "github:Nero-Study-Hat/nixos-config/${branch}" \
--dest "/mnt/${proj_dir}"

# Install
echo $'\n**INSTALLING**\n'
nix shell nixpkgs#git --command nixos-install --impure --flake /mnt/${proj_dir}#stardom