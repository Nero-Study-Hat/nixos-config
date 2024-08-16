#!/usr/bin/env bash

rootPath="$1"

if [[ ! -e "/home/${USER}/.config/hypr/hyprkool.toml" ]]; then
    cp "${rootPath}/configs/hyprkool.toml" "/home/${USER}/.config/hypr/hyprkool.toml"
fi