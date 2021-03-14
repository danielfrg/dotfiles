# ------------------------------------------------------------------------------
# Color scheme
BASE16_SHELL="$HOME/workspace/dotfiles/iterm2/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------------------------------------------------------

export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/make/libexec/gnubin:$PATH
# export PATH=$(brew --prefix coreutils)/libexec/bin:$PATH       # Slow
export PATH=/usr/local/opt/coreutils/libexec/bin:$PATH           # Fast
# export PATH=$(brew --prefix moreutils)/libexec/gnubin:$PATH    # Slow
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH        # Fast

# kegonly brew formulas
export PATH="/usr/local/opt/curl/bin:$PATH"

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
alias j='jobs -l'
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
alias cda='cd ~/workspace/algorithmia'
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


# Enable aliases to be sudo’ed
alias sudo='sudo '

# untar
alias untar='tar xvf'

# NeoVim
alias vim="nvim"
alias vimdiff="nvim -d"

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias allips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

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

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Replacements
alias cat='bat'
alias ccat='/bin/cat'
alias ping='prettyping --nolegend'
alias top='htop'
alias ttop='/usr/bin/top'
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# Linux like commands
alias md5sum='md5 -r'
alias sha256sum="shasum -a 256"

# Helpers
exportpathhere() { export PATH=$(pwd):$PATH }
port_listening_who() { lsof -i ":$1" | grep LISTEN }
alias docker-transmission="open http://localhost:9091 && docker run -it -v ~/Downloads:/downloads -p 9091:9091 linuxserver/transmission"

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_";
}

# Determine size of a file or total size of a directory
function fs() {
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

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}";
  sleep 1 && open "http://localhost:${port}/" &
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

# ===============================================
# KEEP AT THE END: Stuff that want at startup but not commited
touch ~/.zshrc.local
source ~/.zshrc.local
