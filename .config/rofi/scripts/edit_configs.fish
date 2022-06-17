#! /bin/fish

set config_list ~/.config/qtile
set -a config_list ~/.config/alacritty
set -a config_list ~/.config/fish
set -a config_list ~/.config/nvim
set -a config_list /etc/logid.cfg
set -a config_list ~/.config/rofi
set -a config_list ~/.mozilla/firefox/dwj268q6.default-release/chrome/userChrome.css

set choice (printf '%s\n' $config_list | colorful_launcher -dmenu)
if test $choice
    alacritty -e nvim $choice
end
