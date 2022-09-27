#! /usr/bin/env sh

declare -A config_list
config_list[qtile]=~/.config/qtile
config_list[alacritty]=~/.config/alacritty
config_list[fish]=~/.config/fish
config_list[nvim]=~/.config/nvim
config_list[logid]=/etc/logid.cfg
config_list[rofi]=~/.config/rofi
config_list[ranger]=~/.config/ranger
config_list[userChrome]=~/.config/userChrome.css
config_list[zathura]=~/.config/zathura

theme="$HOME/.config/rofi/styles/launcher/tokyothin"
choice=$(printf '%s\n' "${!config_list[@]}" | rofi -theme "$theme" -dmenu -p 'Edit config:')

if [ "$choice" ]; then
    cfg=$(printf '%s\n' "${config_list["${choice}"]}")
    kitty -e $EDITOR $cfg
else
    echo "No Choice"
fi
