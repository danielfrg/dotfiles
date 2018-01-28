# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts
alias cdw='cd ~/workspace'
alias work='cd ~/workspace'
alias cddl="cd ~/Downloads"

# copy file interactive
alias cp='cp -i'

# move file interactive
alias mv='mv -i'

alias k=clear
alias l='ls -lAhG'
alias ls='ls -lAhG'
alias rm='trash'

alias grep='grep -i --color=always'
alias fuck='eval $(thefuck $(fc -ln -1))'

# Typos
alias g='git'
alias it='git'
alias gi='git'
alias tit='git'
alias sl='ls'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# untar
alias untar='tar xvf'

# Replacements
alias ssh=sshrc
alias make=mmake

# Development
alias ec2pubips="aws ec2 describe-instances --query 'Reservations[*].Instances[*].{A_PUB:PublicIpAddress, B_PRIV:NetworkInterfaces[0].PrivateDnsName}' --output text"
