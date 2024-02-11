#!/bin/bash

# partioning (for VirtBox-VM) cmds src 
# https://gist.github.com/Vincibean/baf1b76ca5147449a1a479b5fcc9a222)

# make sure 'Enable EFI' is checked in vm settings

# Partitioning
echo -e $'**PARTITIONING**\n'
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB -4GiB
parted /dev/sda -- mkpart primary linux-swap -4GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp on

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

mount -L nixos /mnt
mkdir -p /mnt/boot/efi
mount -L boot /mnt/boot/efi
swapon /dev/sda2

# Get the repo.
echo -e $'\n**GETTING THE FLAKE REPO**\n'
export NIX_CONFIG="experimental-features = nix-command flakes"
export branch="feat/7-get-my-nixos-project-setup-on-my-pc"
export proj_dir=".n"
nix shell nixpkgs#git --command nix flake clone "github:Nero-Study-Hat/nixos-config/${branch}" \
--dest "/mnt/${proj_dir}"

# Edit the hardware.nix conf file.
echo -e $'\n**EDITING HARDWARE.NIX CONF FILE**\n'
export swap_part_uuid=$(blkid | grep swap | awk '{print $3;}' | grep -o '".*"' | sed 's/"//g')
export swap_line="swapDevices = [{ device = \"/dev/disk/by-uuid/${swap_part_uuid}\"; }];"
export file="/mnt/${proj_dir}/configs/vmtest-hardware-configuration.nix"
sed -i "16i ${swap_line}" "$file"
sed -i '16s/^/'$'\t''/' "$file"

# Install
echo $'\n**INSTALLING**\n'
nix shell nixpkgs#git --command nixos-install --impure --flake /mnt/${proj_dir}#stardom