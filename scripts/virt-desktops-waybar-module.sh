#!/usr/bin/env bash

# Loop forever
while true
do
    text="$1"
    class="virt-desktop-inactive"
    current_desk=$(hyprctl printdesk | awk '{print $3}' | sed 's/://')

    if [ "$text" == "1" ]; then
        text="一"
    elif [ "$text" == "2" ]; then
        text="二"
    elif [ "$text" == "3" ]; then
        text="三"
    elif [ "$text" == "4" ]; then
        text="四"
    fi

    if [ "$current_desk" == "$1" ]; then
        text="◈"
        class="virt-desktop-active"
    fi

    echo ''{\"text\": \" ${text} \", \"class\": \"${class}\"}''
    sleep 2
done