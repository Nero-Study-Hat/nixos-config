#!/usr/bin/env bash
# use "nix shell nixpkgs#git --command " before ./script on fresh sys to work with git

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
    rmdir "$dir"
    ln -s "/mnt/data/${dir}" "/home/${USER}/${dir}"
done

nix run home-manager -- build --flake /.nixflake#alaric
result/activate

rm -rf result
