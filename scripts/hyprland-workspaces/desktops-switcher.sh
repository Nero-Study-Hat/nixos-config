#!/usr/bin/env bash

# requirement: a virtual desktop for each cell in the table of rows*columns

# USER SETTINGS -- WARNING: keep in sync with activity-switcher script
declare -i columns=2
declare -i rows=2
wrapEnable="true"
# -------------------


declare -i currentDesktopNum=$( hyprctl printdesk | awk '{print $3;}' | sed 's/.$//' )
declare -i modifierNum
declare -i targetDesktopNum

cmd="$2"
pluginCmd () {
    if [ "$cmd" == "focus" ]; then
        hyprctl dispatch vdesk ${1}
        exit 1
    elif [ "$cmd" == "window" ]; then
        hyprctl dispatch movetodesk ${1}
        exit 1
    fi
}

declare -i limit=$(($rows + 1))
for (( i=1; i<limit; i++ )) ; {
    # left-most column
    x=$(( $i * $columns - ($columns - 1) ))
    if [ "$x" -eq "$currentDesktopNum" ] && [ "$1" == "left" ]; then
        if [ "$wrapEnable" == "true" ]; then
            targetDesktopNum=$(( $currentDesktopNum + ($columns - 1) ))
            pluginCmd "$targetDesktopNum"
        else
            exit 1
        fi
    fi
    # right-most column
    y=$(( $i * $columns ))
    if [ "$y" -eq "$currentDesktopNum" ] && [ "$1" == "right" ]; then
        if [ "$wrapEnable" == "true" ]; then
            targetDesktopNum=$(( $currentDesktopNum - ($columns - 1) ))
            pluginCmd "$targetDesktopNum"
        else
            exit 1
        fi
    fi
}

if [ "$currentDesktopNum" -ge 1 ] && [ "$currentDesktopNum" -le "$columns" ] && [ "$1" == "up" ]; then
    if [ "$wrapEnable" == "true" ]; then
        targetDesktopNum=$(( $currentDesktopNum + ($columns * ($rows - 1)) ))
        pluginCmd "$targetDesktopNum"
    else
        exit 1
    fi
elif [ "$currentDesktopNum" -ge $(($columns * ($rows - 1) + 1)) ] && [ "$currentDesktopNum" -le $(($rows * $columns)) ] && [ "$1" == "down" ]; then
    if [ "$wrapEnable" == "true" ]; then
        targetDesktopNum=$(($currentDesktopNum - ($columns * ($rows - 1))))
        pluginCmd "$targetDesktopNum"
    else
        exit 1
    fi
fi


if [ "$1" == "right" ]; then
    modifierNum=(1)
elif [ "$1" == "left" ]; then
    modifierNum=(-1)
elif [ "$1" == "up" ]; then
    modifierNum=$(($rows * -1))
elif [ "$1" == "down" ]; then
    modifierNum=($rows)
fi

targetDesktopNum=$(( $currentDesktopNum + $modifierNum ))
pluginCmd "$targetDesktopNum"