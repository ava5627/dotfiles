
# EXPORT 
set fish_greeting                                 # Supresses fish's intro message
set TERM "xterm-256color"                         # Sets the terminal type

if not contains "/home/ava/.local/bin" $PATH
  set PATH $PATH "/home/ava/.local/bin"
end

# set $PATH "~/local/bin:$PATH"

set fish_color_host $fish_color_user
set fish_color_cwd magenta #$fish_color_param
set -g fish_prompt_pwd_dir_length 0


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

alias sai='sudo apt install'
alias sau='sudo apt update && sudo apt upgrade -y'
alias sar='sudo apt auto-remove'

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -A'
alias lla='lsd -lA'
alias lt='lsd --tree'

alias q=exit

alias fuck='sudo (fc -ln -1)'

# Directory cd

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias doc='cd ~/Documents'
alias dow='cd ~/Downloads'
alias root='cd /'

# Programs

alias frc='vim ~/.config/fish/config.fish'
alias brc='vim ~/.bashrc'
alias als='vim ~/.bash_aliases'

# Dotfiles

alias gconfig='git --git-dir=$HOME/repos/dotfiles/ --work-tree=$HOME'

# ssh 

alias avaMSI='ssh ava@avaMSI.local'
alias avaPC='ssh ava@avaPC.local'

# Startup


bind \cH backward-kill-path-component


# neofetch
