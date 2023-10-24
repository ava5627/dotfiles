#!/bin/bash

#starting utility applications at boot time
variety &
nm-applet &
xfce4-power-manager &
numlockx on &
blueberry-tray &
picom --config $HOME/.config/qtile/scripts/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dunst &
xmodmap ~/.config/qtile/scripts/xmodmap &
playerctld &

#starting user applications at boot time
discord &
steam -silent &
openrgb -p Off &
copyq &
kdeconnect-indicator &
morgen --hidden &
insync start &
flameshot &
firefox &
