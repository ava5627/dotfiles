#! /usr/bin/env sh

declare -A config_list
config_list[qtile]=~/.config/qtile
config_list[alacritty]=~/.config/alacritty
config_list[kitty]=~/.config/kitty
config_list[fish]=~/.config/fish
config_list[nvim]=~/.config/nvim
config_list[logid]=/etc/logid.cfg
config_list[rofi]=~/.config/rofi
config_list[ranger]=~/.config/ranger
config_list[userChrome]=~/.config/userChrome.css
config_list[zathura]=~/.config/zathura
config_list[ideavim]=~/.config/ideavim/ideavimrc
config_list[dunst]=~/.config/dunst/dunstrc

declare -A icons_list
icons_list[qtile]=desktop
icons_list[alacritty]=Alacritty
icons_list[kitty]=kitty
icons_list[fish]=fish
icons_list[nvim]=nvim
icons_list[logid]=input-mouse
icons_list[rofi]=view-list-details
icons_list[ranger]=folder
icons_list[userChrome]=firefox
icons_list[zathura]=zathura
icons_list[ideavim]=~/.local/share/JetBrains/Toolbox/toolbox.svg
icons_list[dunst]=notification

cfg=""
for c in ${!config_list[@]}
do
    cfg+="$c\0icon\x1f${icons_list[$c]}\n"
done
# remove last newline
cfg=${cfg::-2}

theme="$HOME/.config/rofi/styles/launcher/tokyothin"
choice=$(echo -e $cfg | rofi -theme "$theme" -dmenu -p 'Edit config:')

export GIT_WORK_TREE=$HOME
export GIT_DIR=$HOME/dotfiles

if [ "$choice" ]; then
    cfg=$(printf '%s\n' "${config_list["${choice}"]}")
    kitty -e $EDITOR $cfg
else
    echo "No Choice"
fi
