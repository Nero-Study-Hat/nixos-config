#!/usr/bin/env bash

if [ "$EUID" == 0 ]; then
    echo "This script should not be run as root."
    exit 1
fi

declare -a home_directories=(
    "Downloads"
    "Documents"
    "Music"
    "Pictures"
    "Videos"
    "Workspace"
)

for dir in "${home_directories[@]}"; do
    ln -s "/mnt/nero-priv-data/${dir}" "/home/${USER}/${dir}"
done

nix run home-manager -- build --flake /.n#nero
result/activate

rm -rf result