#!/usr/bin/env bash

### PLAN ###
#   this will be made as a script and I will make a PR regarding
#   adding this script to the plugin in an associated /scripts dir
#   with it's existence and functionality being explained in the readme
#
# - initial setup
#     - env variable in hyprland config for current activity
#     - create 16 virtual desktops and 4 activities (variable possibilities)
# - bash script for switching current focused virtual desktop based on keyboard shortcut input
#     - check activity variable to choose array of virtual desktops to work with
#     - map desktop in group to 1-4 for simplicity
#     - move between four virtual desktops based on arrow keys behavior in kde
#         - left right conditions - from 1 and 3 always add 1, from 2 and 4 always subtract 1
#         - up down conditions - from 1 and 2 always add 2, from 3 and 4 always subtract 2
#
#   - additional setup
#     - display current (and change-able) activity and virtual desktop from bar


currentDesktopNum=$( hyprctl printdesk | awk '{print $3;}' | sed 's/.$//' )

if [[ "$1" == "left" && "$currentDesktopNum" == "1" ]]; then
    hyprctl dispatch vdesk 3
    exit 1
fi

if [[ "$1" == "right" && "$currentDesktopNum" == "3" ]]; then
    hyprctl dispatch vdesk 1
fi

if [ "$1" == "left" ]; then
    targetDesktopNum=$(("$currentDesktopNum"-1))
    hyprctl dispatch vdesk "$targetDesktopNum"
    exit 1
fi

if [ "$1" == "right" ]; then
    targetDesktopNum=$(("$currentDesktopNum"+1))
    hyprctl dispatch vdesk "$targetDesktopNum"
    exit 1
fi