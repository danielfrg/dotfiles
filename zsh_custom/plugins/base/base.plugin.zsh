# ------------------------------------------------------------------------------
# Color scheme
BASE16_SHELL="$HOME/workspace/dotfiles/iterm2/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Theme

ZSH_THEME="powerlevel10k/powerlevel10k"

# POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir anaconda virtualenv_joined vcs)
# POWERLEVEL9K_DISABLE_RPROMPT=true
# # To print all the colors:
# # for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"
# POWERLEVEL9K_DIR_HOME_FOREGROUND='232'
# POWERLEVEL9K_DIR_HOME_BACKGROUND='012'
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='232'
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='012'
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='232'
# POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='012'
# POWERLEVEL9K_DIR_ETC_FOREGROUND='232'
# POWERLEVEL9K_DIR_ETC_BACKGROUND='012'
# POWERLEVEL9K_ANACONDA_LEFT_DELIMITER=""
# POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER=""
# POWERLEVEL9K_ANACONDA_FOREGROUND='007'
# POWERLEVEL9K_ANACONDA_BACKGROUND='022'
# POWERLEVEL9K_VIRTUALENV_FOREGROUND='007'
# POWERLEVEL9K_VIRTUALENV_BACKGROUND='022'
# POWERLEVEL9K_KUBECONTEXT_FOREGROUND='007'
# POWERLEVEL9K_KUBECONTEXT_BACKGROUND='017'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------------------------------------------------------

export PATH=/usr/local/sbin:$PATH
# export PATH=$(brew --prefix coreutils)/libexec/bin:$PATH       # Slow
export PATH=/usr/local/opt/coreutils/libexec/bin:$PATH           # Fast
# export PATH=$(brew --prefix moreutils)/libexec/gnubin:$PATH    # Slow
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH        # Fast
export PATH=/usr/local/opt/terraform@0.11/bin:$PATH

# Git and GPG
# export GPG_TTY=$(tty)

# This are just bind keys so that they can later be mapped into iterm key combinations
# List all binds with: zle -al
bindkey "^[fw" forward-word       # Bind this to ctrl-(left arrow) = send escape sequence `w`
bindkey "^[bw" backward-word      # Bind this to ctrl-(right arrow) = send escape sequence `b`
bindkey "^[bl" beginning-of-line  # Bind this to cmd-(left arrow) = send escape sequence `bl`
bindkey "^[el" end-of-line        # Bind this to cmd-(right arrow) = send escape sequence `el`
bindkey "^[dw" delete-word                 # Bind this to option(alt)-d = send escape sequence `dw`
bindkey "^[dwb" backward-delete-word       # Bind this to ctrl-w = send escape sequence `dwb`

# History
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
# shopt -s histappend

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# direnv
eval "$(direnv hook zsh)"

# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:$PATH

#########################
# ALIASES
#########################

# List
alias l='ls -lAhG'
alias ls='ls -lAhG'
alias ll='ls -lAhG'
alias la='ls -lAhG'

# Files
# alias rm='rm -i'
# alias rm="echo Use 'trash', or the full path i.e. '/bin/rm'"
alias rm="trash"
alias del="trash"
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p' # -> Prevents accidentally clobbering files.

alias h='history'
# alias j='jobs -l'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias grep='grep -i --color=always'
alias fuck='eval $(thefuck $(fc -ln -1))'
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

# Makes a more readable output.
alias du='du -kh'
alias df='df -kTh'

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts
alias cdw='cd ~/workspace'
alias work='cd ~/workspace'
alias cdr='cd ~/workspace/rstudio'
alias cddw="cd ~/Downloads"

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
alias terrafrom='terraform'

# Git
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'

# NeoVim
alias vim="nvim"
alias vimdiff="nvim -d"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# untar
alias untar='tar xvf'

# Replacements
alias ssh='sshrc'
# alias cat='bat'
alias ping='prettyping --nolegend'
alias top='htop'
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# Linux like commands
alias md5sum='md5 -r'
alias sha256sum="shasum -a 256"

# Helpers
exportpathhere() { export PATH=$(pwd):$PATH }
whoseport() { lsof -i ":$1" | grep LISTEN }
alias docker-transmission="open http://localhost:9091 && docker run -it -v ~/Downloads:/downloads -p 9091:9091 linuxserver/transmission"

# My apps
alias dinero='/Users/danielfrg/conda/envs/dinero/bin/dinero'

# ===============================================
# KEEP AT THE END: Stuff that want at startup but not commited
touch ~/.zshrc.local
source ~/.zshrc.local
