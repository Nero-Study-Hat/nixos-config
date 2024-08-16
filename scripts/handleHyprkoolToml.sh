#!/usr/bin/env bash

rootPath="$1"

if [[ ! -e "/home/${USER}/tmp/test.toml" ]]; then
    cp "${rootPath}/configs/hyprkool.toml" "/home/${USER}/tmp/test.toml"
fi