#!/usr/bin/env bash

# get number of open brave browser windows
# hyprctl clients | grep "class: Brave-browser" | wc -l

# get all open brave browser windows titles
# hyprctl clients | grep title | grep Brave | awk '{gsub("title: ", "");print}' | awk '{$1=$1};1'

# get workspace numbers of all open brave browser windows
# hyprctl clients | grep "class: Brave-browser" -B 4 | grep workspace | awk {'print $2'} | awk '{$1=$1};1'

# move a specific brave window to a specific workspace NOTE: NOT DESKTOP BUT WORKSPACE WHICH IS MONITOR SPECIFIC
# hyprctl "dispatch" "movetodesk 2,title:Passport Forms - Brave"

#TODOS
# - search brave hyprland restore for auto activating the restore option
# - hook into startup and exit of hyprland fro brave restore

if [ ! -f "windows_status.txt" ]; then
    hyprctl clients > windows_status.txt
fi

numWindows=$(cat windows_status.txt | grep "class: Brave-browser" | wc -l)
windowsTitles=$(cat windows_status.txt | grep title | grep Brave | awk '{gsub("title: ", "");print}' | awk '{$1=$1};1')
windowsWorkspaces=$(cat windows_status.txt | grep "class: Brave-browser" -B 4 | grep workspace | awk {'print $2'} | awk '{$1=$1};1')

for (( index=1; index<=numWindows; index++ )) ; {
    title=$(echo "$windowsTitles" | sed -n "${index}p")
    workspace=$(echo "$windowsWorkspaces" | sed -n "${index}p")
    echo "window:"
    echo "movetodesk ${workspace},title:${title}"
    # hyprctl "dispatch" "movetodesk ${workspace},title:${title}"
}

hyprctl clients > windows_status.txt