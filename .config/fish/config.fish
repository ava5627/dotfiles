
# EXPORT
set fish_greeting                                 # Supresses fish's intro message
export TERM="xterm-256color"                         # Sets the terminal type

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

# clean home dir
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export HISTFILE="$XDG_STATE_HOME/bash/history"

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
alias ys='yay -Syu'
alias yss='yay -Ss'

# ls
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -A'
alias lla='lsd -lA'
alias lt='lsd --tree'

alias ip='ip --color=auto'

alias q=exit

alias f='commandline -i "sudo $history[1]";history delete --exact --case-sensitive f'

alias vim='nvim'

alias qlog='watch -n 0.5 tail ~/.local/share/qtile/qtile.log -n 30'

alias rgr='ranger'

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
