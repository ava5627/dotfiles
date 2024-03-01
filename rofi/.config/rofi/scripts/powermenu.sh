#!/usr/bin/env bash

## Edited version of powermenu script from https://github.com/adi1090x/rofi

dir="$HOME/.config/rofi/styles/powermenu"
rofi_command="rofi -theme $dir/powermenu.rasi -kb-select-1 s -kb-select-2 r -kb-select-3 l -kb-select-4 u"

uptime=$(uptime -p | sed -e 's/up //g')

# Options
shutdown="󰐥"
reboot="󰜉"
lock=""
suspend=""

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
