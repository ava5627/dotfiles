#!/usr/bin/env bash

## Edited version of powermenu script from https://github.com/adi1090x/rofi

dir="$HOME/.config/rofi/styles/powermenu"
rofi_command="rofi -theme $dir/powermenu.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

# Options
shutdown=""
reboot=""
lock=""
suspend=""

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 3)"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        betterlockscreen -l
        ;;
    $suspend)
        systemctl suspend
        ;;
esac
