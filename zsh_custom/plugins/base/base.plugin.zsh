# Color scheme
BASE16_SHELL="$HOME/code/dotfiles/iterm2/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

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
    # Mac only!

    # Switch Homebrew path based on whether we're native or in Rosetta
    if [ "$(sysctl -n sysctl.proc_translated)" = "1" ]; then
        local brew_path="/usr/local/homebrew/bin"
    else
        local brew_path="/opt/homebrew/bin"
    fi
    eval $($brew_path/brew shellenv)

    # Homebrew things
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/opt/make/libexec/gnubin:$PATH
    # export PATH=$(brew --prefix coreutils)/libexec/bin:$PATH       # Slow
    export PATH=/usr/local/opt/coreutils/libexec/bin:$PATH           # Fast
    # export PATH=$(brew --prefix moreutils)/libexec/gnubin:$PATH    # Slow
    export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH        # Fast

    # kegonly brew formulas
    export PATH="/usr/local/opt/curl/bin:$PATH"

    # Completitions
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"

    # Git and GPG config
    export GPG_TTY=$TTY

    alias rm="trash"
else
    # echo 'Unknown OS!'
fi

# Local binaries
export PATH=$HOME/.local/bin:$HOME/.local/scripts:$PATH
# Binaries inside dotfiles
export PATH=$HOME/code/dotfiles/bin:$PATH

eval "$(starship init zsh)"

# History
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoredups:ignorespace
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

#########################
# ALIASES
#########################

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Replacements
# From: https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
alias cat='bat --style="header"'
alias ccat='/bin/cat'
alias df='duf'
alias ddf='/usr/df'
alias grep='rp'
alias grep='grep -i --color=always'
alias find='fd -H'
alias ffind='/usr/bin/find'
alias ls='lsd -la'
alias lls='/bin/ls'
alias ping='prettyping --nolegend'
alias pping='/sbin/ping'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias top='btm'
alias ttop='/usr/bin/top'
alias watch=viddy
alias wwatch='/opt/homebrew/bin/watch'

# Files
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

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

# Shortcuts
alias cdc='cd ~/code'
alias cdg='cd ~/google'
alias cdd="cd ~/Downloads"

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

# NeoVim
alias c="nvim"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias allips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

alias httpserver="open http://localhost:8000 && python -m http.server 8000"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

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

function clipvideo() {
  if [ $# -ne 2 ]
    then
        echo "Arguments: <input> <start> <end> <output>"
    else
        grep -rnw $1 -e $2
    fi
    ffmpeg -i  $1 -ss $2 -to $3 -c:v copy -c:a copy $4
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

# ===============================================
# KEEP AT THE END: Stuff that want at startup but not commited
touch ~/.zshrc.local
source ~/.zshrc.local
