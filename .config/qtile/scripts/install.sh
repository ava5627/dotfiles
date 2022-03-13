pacman -Syu qtile firefox alacritty xorg-xinit sddm xorg-server xorg-apps
pacman -Syu --asdeps alsa-utils libpulse python-dbus-next python-psutil python-xlib python-tomali mypy
pacman -Syu network-manager-applet steam kdeconnect variety xfce4-power-manager numlockx blueberry picom polkit-gnome rofi discord steam openrgb copyq pcmanfm maim qalculate-gtk neovim btop

systemctl enable sddm
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd .. && rm -rf yay
