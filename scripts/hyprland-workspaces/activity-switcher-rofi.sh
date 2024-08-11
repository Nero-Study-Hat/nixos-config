#!/usr/bin/env bash

# requirement: a virtual desktop for each cell in the table of rows*columns

# USER SETTINGS -- WARNING: keep in sync with desktop-switcher script
declare -i columns=2
declare -i rows=2
declare -a activities=("tech" "writing" "slack")
# -------------------

activity=$(printf "%s\n"  "${activities[@]}" | rofi -dmenu -p 'Choose activity')
declare -i cellNumber=$(( "$rows" * "$columns" ))
declare -i currentDesktop=$( hyprctl printdesk | awk '{print $3;}' | sed 's/.$//' )

declare -i currentActivityNum
i=(1)
while [ "$i" -le "${#activities[@]}" ]
do
    if [ "$currentDesktop" -le $(( "$cellNumber" * "$i" ))  ]; then
        currentActivityNum="$i"
        break
    fi
    i=$(( "$i" + 1 ))
done

declare -i targetActivityNum
for i in "${!activities[@]}"; do
   if [[ "${activities[$i]}" = "${activity}" ]]; then
       targetActivityNum=$(( "$i" + 1 ))
       break
   fi
done

declare -i activityChangeDiff=$(( "$targetActivityNum" - "$currentActivityNum" ))
declare -i newDesktop=$(( "$currentDesktop" + ( "$activityChangeDiff" * "$cellNumber" ) ))

cmd="$1"
if [ "$cmd" == "focus" ]; then
    hyprctl dispatch vdesk ${newDesktop}
    exit 1
elif [ "$cmd" == "window" ]; then
    hyprctl dispatch movetodesk ${newDesktop}
    exit 1
fi
