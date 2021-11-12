# Quick aliases

alias cls='clear'
alias cla='clear; source ~/.bashrc'

alias sai='sudo apt install'
alias sau='sudo apt update && sudo apt upgrade -y'
alias sar='sudo apt auto-remove'

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -A'
alias lla='lsd -lA'
alias lt='lsd --tree'

alias q=exit

alias fuck='sudo $(fc -ln -1)'

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

# ssh 

alias avaMSI='ssh ava@avaMSI.local'
alias avaPC='ssh ava@avaPC.local'
