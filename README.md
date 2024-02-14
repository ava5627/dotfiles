# My Dotfiles

## Prerequisites

- [Git](https://git-scm.com/)
    - Arch Linux: `sudo pacman -S git`
    - MacOS: `brew install git`
- [GNU Stow](https://www.gnu.org/software/stow/)
    - Arch Linux: `sudo pacman -S stow`
    - MacOS: `brew install stow`

## Installation
```sh
git clone https://github.com/ava5627/dotfiles.git
cd dotfiles
```

## Individual Package Requirements
- [Neovim](https://neovim.io/): Terminal text editor
    - Arch Linux: `sudo pacman -S neovim`
    - MacOS: `brew install neovim`
    - Neovim Requirements:
        - xclip: required for clipboard support
        - python + pynvim
        - nodejs: only required for copilot
        - ripgrep: required for telescope.nvim
        - fd: required for telescope.nvim
- [Qtile](http://www.qtile.org/): Tiling window manager written in Python
    - Arch Linux: `sudo pacman -S qtile`
    - MacOS: Not supported
    - qtile Requirements:
        - picom: required for transparency
        - py-yaml: required for reading theme files
        - alsa-utils: required for volume control widget
        - python-bowler: required for migrating config files
        - python-dbus-next: required for utils and widgets
        - python-psutil: required for widgets
        - python-setproctitle: required to change process name
- [Fish](https://fishshell.com/): User-friendly shell
    - Arch Linux: `sudo pacman -S fish`
    - MacOS: `brew install fish`
    - Fish Requirements:
        - [lsd](github.com/lsd-rs/lsd): better ls command
        - [zoxide](github.com/ajeetdsouza/zoxide): better cd command
        - [neofetch](github.com/dylanaraps/neofetch): system info
        - [bat](github.com/sharkdp/bat): better pager
        - [difftastic](github.com/Wilfred/difftastic): better diff
- [copyq](https://hluk.github.io/CopyQ/): Clipboard manager
    - Arch Linux: `sudo pacman -S copyq`
    - MacOS: `brew install --cask copyq`
- [Kitty](https://sw.kovidgoyal.net/kitty/): Terminal emulator
    - Arch Linux: `sudo pacman -S kitty`
    - MacOS: `brew install kitty`
- [Rofi](https://github.com/davatorium/rofi): Application launcher and menu
    - Arch Linux: `sudo pacman -S rofi`
    - MacOS: Use spotlight
- [dunst](https://dunst-project.org/): Notification daemon
    - Arch Linux: `sudo pacman -S dunst`
    - MacOS: Not supported
- [logiops](https://github.com/PixlOne/logiops): Logitech mouse configuration
    - Arch Linux:
        ```sh
        yay -S logiops-git
        ln -s ~/.config/logid.cfg /etc/logid.cfg
        ```
    - MacOS: Not supported
- [userChrome.css](http://kb.mozillazine.org/index.php?title=UserChrome.css): Firefox customization
    - Arch Linux: `pacman -S firefox`
    - MacOS: `brew install firefox`
        ```sh
        mkdir ~/.mozilla/firefox/<profile>/chrome
        ln -s ~/.config/logiops/logiops.conf ~/.mozilla/firefox/<profile>/chrome/logiops.conf
        ```
