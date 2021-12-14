
# EXPORT 
set fish_greeting                                 # Supresses fish's intro message
set TERM "xterm-256color"                         # Sets the terminal type

if not status --is-interactive
  exit
end


fish_add_path "/home/ava/.local/bin"

# set $PATH "~/local/bin:$PATH"

set fish_color_host $fish_color_user
set fish_color_cwd magenta #$fish_color_param
set -g fish_prompt_pwd_dir_length 0

set GEM_HOME (ruby -e 'puts Gem.user_dir')
fish_add_path $GEM_HOME/bin

set EDITOR nvim

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

alias cls='clear'
alias cla='clear; exec fish'

alias pacs='sudo pacman -S'
alias pacu='sudo pacman -Syyu'
alias pacr='sudo pacman -R'
alias pacss='pacman -Ss'
alias pacar='sudo pacman -Qtdq | sudo pacman -Rns -'

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -A'
alias lla='lsd -lA'
alias lt='lsd --tree'

alias q=exit

alias f='commandline -i "sudo $history[1]";history delete --exact --case-sensitive f'

alias vim='nvim'

alias qlog='watch -n 0.5 tail ~/.local/share/qtile/qtile.log -n 50'

# Directory cd

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias doc='cd ~/Documents'
alias dow='cd ~/Downloads'
alias root='cd /'

# Dotfiles

alias gconfig='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Startup

bind \cH backward-kill-path-component


neofetch
