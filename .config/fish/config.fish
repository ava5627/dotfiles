# EXPORT
set fish_greeting                                 # Supresses fish's intro message

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.config/rofi/bin"

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=/run/user/(id -u)

set fish_color_host $fish_color_user
set fish_color_cwd magenta #$fish_color_param
set -g fish_prompt_pwd_dir_length 0

export EDITOR=nvim
export QT_STYLE_OVERRIDE=kvantum
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# clean home dir
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export CUDA_CACHE_PATH=$XDG_CACHE_HOME/nv
export HISTFILE=$XDG_STATE_HOME/bash/history
export GNUPGHOME=$XDG_DATA_HOME/gnupg
export SCREENRC=$XDG_CONFIG_HOME/screen/screenrc
export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
export NUGET_PACKAGES=$XDG_CACHE_HOME/NuGetPackages
export KERAS_HOME=$XDG_STATE_HOME/keras
export WINEPREFIX="$XDG_DATA_HOME"/wine
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export GOPATH="$XDG_CONFIG_HOME"/go
export ANDROID_HOME="$XDG_DATA_HOME"/android
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export ZDOTDIR="$HOME"/.config/zsh
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'

if not status --is-interactive
  exit
end


function fish_user_key_bindings
    # fish_vi_key_bindings
    # bind -M insert \cq kill-whole-line
    fish_default_key_bindings
    bind \cq kill-whole-line
end

function fish_prompt --description 'Write out the prompt'

#   # User
#   set_color $fish_color_user --bold
#   echo -n $USER
#   set_color normal --bold

#   echo -n '@'

#   # Host
#   set_color $fish_color_host --bold
#   echo -n (prompt_hostname)
#   set_color normal --bold

#   echo -n ':'

#   # PWD
    set_color $fish_color_user --bold
    echo -n (prompt_pwd)
    set_color normal --bold

    echo -n ' $ '

end

# Quick aliases

# clear
alias cls='clear'
alias c='clear'
alias cla='clear; exec fish'

# pacman
alias pacs='sudo pacman -Syu'
alias pacq='pacman -Q'
alias pacr='sudo pacman -Rns'
alias pacss='pacman -Ss'
alias pacqs='pacman -Qs'
alias pacar='sudo pacman -Rns (pacman -Qtdq)'

# yay
alias ys='yay -Sua'
alias yss='yay -Ss'

# ls
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -A'
alias lla='lsd -lA'
alias lt='lsd --tree'

alias ip='ip --color=auto'

alias q=exit

alias vim='nvim'
alias v='nvim .'

alias qlog='watch -n 0.5 tail ~/.local/share/qtile/qtile.log -n 30'

alias ranger='ranger --choosedir=/tmp/ranger_dir; set LASTDIR (cat /tmp/ranger_dir); cd $LASTDIR; rm /tmp/ranger_dir'


# python
alias vc='python -m venv .venv'
alias va='source ./.venv/bin/activate.fish'
alias vv='source ./.venv/bin/activate.fish & nvim .'


# Directory cd

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Dotfiles

alias gconfig='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Startup
neofetch
