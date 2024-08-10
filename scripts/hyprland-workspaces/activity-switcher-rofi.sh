#!/usr/bin/env bash

# requirement: a virtual desktop for each cell in the table of rows*columns

# USER SETTINGS -- WARNING: keep in sync with desktop-switcher script
declare -i columns=2
declare -i rows=2
declare -a activities=("tech" "writing" "slack")
# -------------------

# activity=$(printf "%s\n"  "${activities[@]}" | rofi -dmenu -p 'Choose activity')
# declare -i currentDesktop=$( hyprctl printdesk | awk '{print $3;}' | sed 's/.$//' )
# declare -i currentActivityNum # ?
# declare -i activityChangeDiff

# for i in "${!activities[@]}"; do
#    if [[ "${activities[$i]}" = "${activity}" ]]; then
#        activityNum="$i"
#        break
#    fi
# done

# declare -i newDesktop=(( "$currentDesktop" + ( "$activityChangeDiff" * ("$rows" * "$columns")) ))

numerator=90
denominator=7
python -c "print (round(${numerator}.0 / ${denominator}.0))"