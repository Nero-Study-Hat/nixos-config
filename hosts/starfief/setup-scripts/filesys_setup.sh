#!/usr/bin/env bash

read -p $'nix-shell https://github.com/sgillespie/nixos-yubikey-luks/archive/master.tar.gz\nEnter (yes/y) if you have run the above command: ' shell_status

if [[ "$shell_status" != "yes" && "$shell_status" != "y" ]]; then
    echo "run the command before the script"
    exit
fi

EFI_PART="/dev/nvme0n1p1"
EFI_MNT="/mnt/boot"
LUKS_PART="/dev/nvme0n1p2"
LUKSROOT="encrypted"

function luks_yubikey_setup () {
    # Key Setup
    echo -e $'\n**LUKS Yubikey Setup**\n'

    SALT_LENGTH=16
    SALT="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"

    CHALLENGE="$(echo -n $SALT | openssl dgst -binary -sha512 | rbtohex)"
    RESPONSE=$(ykchalresp -2 -x $CHALLENGE 2>/dev/null)

    KEY_LENGTH=512
    ITERATIONS=100000

    LUKS_KEY="$(echo | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $RESPONSE | rbtohex)"

    CIPHER="aes-xts-plain64"
    HASH="sha512"

    # Key Storing (use pre-existing efi partition)
    mkdir -p "$EFI_MNT"
    mount "$EFI_PART" "$EFI_MNT"

    STORAGE="/crypt-storage/default"
    mkdir -p "$(dirname ${EFI_MNT}${STORAGE})"
    echo -ne "$SALT\n$ITERATIONS" > "${EFI_MNT}${STORAGE}"

    # Create LUKS Device
    # multi-line command didn't work
    echo -n "$LUKS_KEY" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- "$LUKS_PART"

    umount "$EFI_PART"
    rmdir "$EFI_MNT"

    echo -n "$LUKS_KEY" | hextorb | cryptsetup luksOpen $LUKS_PART $LUKSROOT --key-file=-
}

function lvm_partitions_setup () {
    echo -e $'\n**SETTING UP LVM Partitions**\n'

    pvcreate "/dev/mapper/$LUKSROOT"

    VGNAME="partitions"
    vgcreate "$VGNAME" "/dev/mapper/$LUKSROOT"

    lvcreate -L 16G -n swap "$VGNAME"
    FSROOT="nixos"
    lvcreate -l 100%FREE -n "$FSROOT" "$VGNAME"

    vgchange -ay

    mkswap -L swap "/dev/partitions/swap"
    mkfs.ext4 -L "$FSROOT" "/dev/partitions/$FSROOT"

    mount "/dev/partitions/$FSROOT" "/mnt"
    mkdir -p "$EFI_MNT"
    mount "$EFI_PART" "$EFI_MNT"
    swapon /dev/partitions/swap
}

luks_yubikey_setup
lvm_partitions_setup

echo -e $'\n**Now run the following commands:**\n'
echo "exit && exit"
echo "./copy_keys.sh"