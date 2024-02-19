set fish_greeting                                 # Supresses fish's intro message

# add to path if not already there
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.config/rofi/bin"
fish_add_path "/usr/lib/jvm/default/bin"
fish_add_path "$XDG_DATA_HOME/cargo/bin"

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
export MANROFFOPT="-c"

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
export PARALLEL_HOME="$XDG_DATA_HOME"/parallel
export JAVA_HOME="/usr/lib/jvm/default"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export VIRTUAL_ENV_DISABLE_PROMPT=1
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export NODE_REPL_HISTORY_FILE="$XDG_DATA_HOME"/node_repl_history

if set -q VIRTUAL_ENV && contains $VIRTUAL_ENV/bin $PATH
    set index (contains -i $VIRTUAL_ENV/bin $PATH)
    set -ge PATH[$index]
    set -gxp PATH $VIRTUAL_ENV/bin
end

# If not running interactively, don't continue
if not status --is-interactive
  exit
end


function fish_user_key_bindings
    # fish_vi_key_bindings
    # bind -M insert \cq kill-whole-line
    fish_default_key_bindings
    bind \cq kill-whole-line
end

# programs
zoxide init fish --cmd cd | source

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
alias pacsi='pacman -Si'
alias pacqs='pacman -Qs'
alias pacqi='pacman -Qi'
alias pacar='sudo pacman -Rns (pacman -Qtdq)'

# yay
alias ys='yay -Sua'
alias yss='yay -Ss'

# ls
alias ls='lb'
alias ll='lb -l'
alias la='lb -A'
alias lla='lb -lA'


alias ip='ip --color=auto'

alias q=exit

alias vim='nvim'
alias v='nvim .'

alias qlog='clear && tail -f ~/.local/share/qtile/qtile.log'

alias ranger='ranger --choosedir=/tmp/ranger_dir; set LASTDIR (cat /tmp/ranger_dir); cd $LASTDIR; rm /tmp/ranger_dir'


# python
alias vc='python -m venv .venv'
alias va='source ./.venv/bin/activate.fish'
alias vv='source ./.venv/bin/activate.fish & nvim .'

alias cam='mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'

# Directory cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cb='cd -'

# Dotfiles
alias gconfig='git --git-dir=$HOME/dotfiles/.git --work-tree=$HOME/dotfiles'

abbr -a gs 'git status'
abbr -a gsb 'git status -sb'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gcm 'git commit -m'

# Startup
neofetch
