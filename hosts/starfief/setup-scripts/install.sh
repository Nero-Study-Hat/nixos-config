#!/usr/bin/env bash

if [ $# -eq 0 ]; then
   echo -e "need argument(s), need\nIP address for ssh remote_dest \nyes/y for format_check if applicable"
   exit 1
fi

remote_user="root"
remote_host="$1"
format_check="$2"

function format_partitions () {
    if [[ "$format_check" != "yes" && "$format_check" != "y" ]]; then
        return 1
    fi
    echo -e $'\n**Formating Partitions**\n'
    # assume pre-existing partitions and format them
    # efi partition
    # ext4 partition
    EFI_PART_LABEL="UEFI"
    LINUX_PART_LABEL="linux"

    if blkid | grep -q "LABEL=\"${EFI_PART_LABEL}\""; then
        mkfs.fat -F "32" -n "$EFI_PART_LABEL" "/dev/nvme0n1p1"
    fi
    if blkid | grep -q "PARTLABEL=\"${LINUX_PART_LABEL}\""; then 
        mkfs.ext4 -L "$LINUX_PART_LABEL" "/dev/nvme0n1p2"
    fi
}

ssh "${remote_user}@${remote_host}" 'bash -s' <<EOT
    $(declare -p format_check)
    $(declare -f format_partitions)
    format_partitions
EOT


function final_prompt () {
    echo -e $'\n**Now run the following commands:**'
    echo "cd / && nix-shell https://github.com/sgillespie/nixos-yubikey-luks/archive/master.tar.gz"
    echo -e $'./filesys_setup\n'
}

read -p $'Copy script to ISO (yes/y): ' copy_check

if [[ "$copy_check" != "yes" && "$copy_check" != "y" ]]; then
    final_prompt
    ssh "${remote_user}@${remote_host}"
    exit
fi

script1="filesys_setup.sh"
scp "$script1" "${remote_user}@${remote_host}:/${script1}"

final_prompt

ssh "${remote_user}@${remote_host}"