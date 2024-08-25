#!/usr/bin/env bash

# manual commands to execute from
# su -
# nix-shell https://github.com/sgillespie/nixos-yubikey-luks/archive/master.tar.gz

# assume pre-existing
# efi partition
# ext4 partition

# Key Setup
SALT_LENGTH=16
SALT="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"

CHALLENGE="$(echo -n $SALT | openssl dgst -binary -sha512 | rbtohex)"
RESPONSE=$(ykchalresp -2 -x $CHALLENGE 2>/dev/null)

KEY_LENGTH=512
ITERATIONS=10000

LUKS_KEY="$(echo | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $RESPONSE | rbtohex)"

CIPHER="aes-xts-plain64"
HASH="sha512"

# Key Storing (use pre-existing efi partition)
EFI_PART="/dev/nvme0n1p1"
EFI_MNT="/mnt/boot/efi"
mkdir -p "$EFI_MNT"
mount "$EFI_PART" "$EFI_MNT"

STORAGE="/crypt-storage/default"
mkdir -p "$(dirname ${EFI_MNT}${STORAGE})"
echo -ne "$SALT\n$ITERATIONS" > "${EFI_MNT}${STORAGE}"

# Create LUKS Device
LUKS_PART="/dev/nvme0n1p2"
# multi-line command didn't work
echo -n "$LUKS_KEY" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- "$LUKS_PART"