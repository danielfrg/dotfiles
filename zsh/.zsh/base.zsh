# This are bind keys so that they can later be mapped into iterm2 key combinations
# To list all binds run: zle -al
bindkey "^[fw" forward-word             # Bind this to ctrl-(left arrow) = send escape sequence `w`
bindkey "^[bw" backward-word            # Bind this to ctrl-(right arrow) = send escape sequence `b`
bindkey "^[bl" beginning-of-line        # Bind this to cmd-(left arrow) = send escape sequence `bl`
bindkey "^[el" end-of-line              # Bind this to cmd-(right arrow) = send escape sequence `el`
bindkey "^[dw" delete-word              # Bind this to option(alt)-d = send escape sequence `dw`
bindkey "^[dwb" backward-delete-word    # Bind this to ctrl-w = send escape sequence `dwb`

# ------------------------------------------------------------------------------

if [[ $(uname) == "Darwin" ]]; then
    # Mac only

    # Switch Homebrew path based on whether we're native or in Rosetta
    # if [ "$(sysctl -n sysctl.proc_translated)" = "1" ]; then
    #     local brew_path="/usr/local/homebrew/bin"
    # else
    #     local brew_path="/opt/homebrew/bin"
    # fi

    # Do this manually to make it faster
    # Start: eval $($brew_path/brew shellenv)
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
    export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
    # End manual brew path

    # GNU tools
    export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH
    export PATH=$HOMEBREW_PREFIX/opt/fastutils/libexec/gnubin:$PATH

    # kegonly brew formulas
    export PATH="/usr/local/opt/curl/bin:$PATH"

    # Completitions
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"

    # Git and GPG config
    export GPG_TTY=$TTY

    alias rm_="/bin/rm"
    alias rm="trash"

    # Lock the screen (when going AFK)
    alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
else
    # echo 'Unknown OS!'
fi

# Binaries inside dotfiles
export PATH=$HOME/code/dotfiles/bin:$PATH

# Local binaries
export PATH=$HOME/.local/bin:$HOME/.local/scripts:$PATH

# Cargo binaries
export PATH=$HOME/.cargo/bin:$PATH

# Prompt
eval "$(starship init zsh)"

# History
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoredups:ignorespace
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

#########################
# ALIASES
#########################

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Files
alias l='ls -la'
alias ls='ls -la'
alias la='ls -la'
alias lla='ls -la'
alias lt='ls --tree'
alias preview="fzf --preview 'bat --color \"always\" {}'"

# alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p' # Prevents accidentally clobbering files.

alias h='history'
alias which='type -a'
alias echopath='echo -e ${PATH//:/\\n}'
alias echolibpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

# Makes a more readable output.
alias du='du -kh'
# alias df='df -kTh'

# Navigation
bindkey -s ^f "tmux-sessionizer\n"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cdc='cd ~/code'
alias cdg='cd ~/google'
alias cdd="cd ~/Downloads"
alias t="tmux"
alias ta="tmux attach"

# Typos
alias g='git'
alias it='git'
alias gi='git'
alias tit='git'
alias sl='ls'

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
alias gitwip='git commit -am "wip"'
alias gw='git commit -am "wip"'
alias gu='git commit -am "update"'

# untar
alias untar='tar xvf'

# GNU tools
alias sed_="/usr/bin/sed"
alias sed="gsed"

# NeoVim
alias vim_="/usr/bin/vim"
alias c="nvim"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"

# Fancy replacements for common commands
# From: https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
if [[ $(uname) == "Darwin" ]]; then
    alias cat='bat --style="header"'
    alias cat_='/bin/cat'
    alias df='duf'
    alias df_='/usr/df'
    alias grep='rg'
    alias grep_='/usr/bin/grep -i --color=always'
    alias find='fd -H'
    alias find_='/usr/bin/find'
    alias ls='exa -la --icons --group-directories-first'
    alias ls_='/bin/ls'
    alias ping='prettyping --nolegend'
    alias ping_='/sbin/ping'
    alias top='btm'
    alias top_='/usr/bin/top'
    alias watch=viddy
    alias watch_='/opt/homebrew/bin/watch'
fi

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias allips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

alias httpserver="open http://localhost:8000 && python -m http.server 8000"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# Linux like commands
alias md5sum='md5 -r'
alias sha256sum="shasum -a 256"

# Helpers
exportpathhere() { export PATH=$(pwd):$PATH }
port_listening_who() { lsof -i ":$1" | grep LISTEN }

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_";
}

function search() {
  if [ $# -ne 2 ]
    then
        echo "Arguments: path pattern"
    else
        grep -rnw $1 -e $2
    fi
}

# Determine size of a file or total size of a directory
function dirsize() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* *;
  fi;
}

function clipvideo() {
  if [ $# -ne 2 ]
    then
        echo "Arguments: <input> <start> <end> <output>"
    else
        grep -rnw $1 -e $2
    fi
    ffmpeg -i  $1 -ss $2 -to $3 -c:v copy -c:a copy $4
}

# Kubernetes -------------------------------------------------------------------

alias k='kubectl'
alias kubecl='kubectl'
alias kubect='kubectl'
alias kubelt='kubectl'
alias kubeclt='kubectl'
alias kuebctl='kubectl'
alias kns='kubens'
alias kctx='kubectx'
alias terrafrom='terraform'
alias tf='terraform'

kubedecode() {
    if [ $# -ne 2 ]
    then
        echo "Arguments: secret_name key"
    else
        kubectl get secret $1 -o json | jq -r ".[\"data\"][\"$2\"]" | base64 --decode
    fi
}

kexec() {
    if [ $# -ne 1 ]
    then
        echo "Arguments: pod_name"
    else
        kubectl exec -it $1 -- bash
    fi
}

# DOCKER -----------------------------------------------------------------------

docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() { docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
docker-rmi-prefix () { docker rmi -f $(docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}') }
docker-rmi-all () { docker rmi -f $(docker images --format '{{.ID}}') }

