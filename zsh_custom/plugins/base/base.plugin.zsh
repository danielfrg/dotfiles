## For some stuff that want at startup but not commited
source ~/.zshrc.local

#########################
# POWERLINE-GO
# PROMPT REPLACEMENT
#########################

function powerline_precmd() {
    PS1="$(/usr/local/bin/powerline-go -shell zsh -modules venv,kube,cwd,git,exit -error $? -newline -shorten-gke-names)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

#########################

# Color scheme
BASE16_SHELL="$HOME/workspace/dotfiles/iterm2/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export PATH=/usr/local/sbin:$PATH
# export PATH=$(brew --prefix coreutils)/libexec/bin:$PATH    # Slow
export PATH=/usr/local/opt/coreutils/libexec/bin:$PATH        # Fast
# export PATH=$(brew --prefix moreutils)/libexec/gnubin:$PATH    # Slow
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH        # Fast

# This are just bind keys so that they can later be mapped into iterm key combinations
# List all binds with: zle -al
bindkey "^[fw" forward-word       # Bind this to ctrl-(left arrow) = send escape sequence `w`
bindkey "^[bw" backward-word      # Bind this to ctrl-(right arrow) = send escape sequence `b`
bindkey "^[bl" beginning-of-line  # Bind this to cmd-(left arrow) = send escape sequence `bl`
bindkey "^[el" end-of-line        # Bind this to cmd-(right arrow) = send escape sequence `el`
bindkey "^[dw" delete-word                 # Bind this to option(alt)-d = send escape sequence `dw`
bindkey "^[dwb" backward-delete-word       # Bind this to ctrl-w = send escape sequence `dwb`

#########################
# ALIASES
#########################

# Easier navigation
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

# listing
alias l='ls -lAhG'
alias ls='ls -lAhG'

alias grep='grep -i --color=always'
alias fuck='eval $(thefuck $(fc -ln -1))'

# Typos
alias g='git'
alias it='git'
alias gi='git'
alias tit='git'
alias sl='ls'
alias k='kubectl'
alias kubecl='kubectl'
alias kubect='kubectl'
alias kubelt='kubectl'
alias kubeclt='kubectl'
alias kuebctl='kubectl'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# untar
alias untar='tar xvf'

# Replacements
# alias rm='trash'
alias ssh='sshrc'
alias cat='bat'
alias ping='prettyping --nolegend'
alias top='htop'
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# Linux like commands
alias md5sum='md5 -r'
alias sha256sum="shasum -a 256"

# Helpers
whoseport() { lsof -i ":$1" | grep LISTEN }
alias docker-transmission="open http://localhost:9091 && docker run -it -v ~/Downloads:/downloads -p 9091:9091 linuxserver/transmission"
