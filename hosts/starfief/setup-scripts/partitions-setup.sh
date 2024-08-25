#!/usr/bin/env bash

# Setup LVM Partitioning

EFI_PART="/dev/nvme0n1p1"
EFI_MNT="/mnt/boot/efi"

umount "$EFI_PART"
rmdir "$EFI_MNT"

LUKSROOT="nixos-enc"
pvcreate "/dev/mapper/$LUKSROOT"

VGNAME="partitions"
vgcreate "$VGNAME" "/dev/mapper/$LUKSROOT"

lvcreate -L 16G -n swap "$VGNAME"
FSROOT="nixos"
lvcreate -l 100%FREE -n "$FSROOT" "$VGNAME"

vgchange -ay

mkswap -L swap "/dev/partitions/swap"
mkfs.ext4 -L "$FSROOT" "/dev/partitions/$FSROOT"

# Final Partition Mounts Handling
mount "/dev/partitions/$FSROOT" "/mnt"
mkdir -p "$EFI_MNT"
mount "$EFI_PART" "$EFI_MNT"
swapon /dev/partitions/swap