#!/usr/bin/env bash

# activates
#   - alongside activity change hyprland keybind
#   - from activity module on-click: switcher-exe && this-script

flakeDir=""
for i in {1..3}
do
    flakeDir=$(dirname -- "$(readlink -f -- "$flakeDir")")
done
currentActivity=$("${flakeDir}/pkgs/waybar-modules/activity" 1)

if [ "$currentActivity" == "TECH" ]; then
    echo tech
elif [ "$currentActivity" == "WRITING" ]; then
    echo writing
fi

echo "/home/${USER}/"