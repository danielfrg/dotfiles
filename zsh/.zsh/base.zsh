if [[ $(uname) == "Darwin" ]]; then
    # Pasted here explicitly to make it faster
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
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

    # Git and GPG config
    export GPG_TTY=$TTY

    alias rm_="/bin/rm"
    alias rm="trash"

    zle -N project_switcher{,}

    # ctrl-f for tmux-sessionizer
    bindkey -s "^F" "tmux-sessionizer\n"

    alias cdc='tmux-sessionizer'
else
    # echo 'Unknown OS!'
fi

export XDG_CONFIG_HOME=$HOME/.config

# Local binaries
export PATH=$HOME/.local/bin:$HOME/.local/scripts:$PATH

# Cargo binaries
export PATH=$HOME/.cargo/bin:$PATH

# History config
HISTSIZE=1000000000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

eval "$(fzf --zsh)"

# History: Atuin
local FOUND_ATUIN=$+commands[atuin]
if [[ $FOUND_ATUIN -eq 1 ]]; then
  source <(atuin init zsh --disable-up-arrow)
fi

#########################
# ALIASES
#########################

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

project_switcher() {
  selected=$(find_ ~/code ~/code/danielfrg ~/code/inmatura ~/nvidia -mindepth 1 -maxdepth 1 -type d | fzf)

  if [[ -z $selected ]]; then
      exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)

  echo "cd $selected"
  cd $selected
}

# fancy tools
if command -v eza > /dev/null 2>&1; then
  alias ls='eza'
fi
alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias lt='ls --tree'

if [[ $(uname) == "Darwin" ]]; then
  alias cat='bat --style="header"'
  alias cat_='/bin/cat'
  alias df='duf'
  alias df_='/usr/df'
  alias grep='rg'
  alias grep_='/usr/bin/grep -i --color=always'
  alias find='fd -H'
  alias find_='/usr/bin/find'
  alias ping='prettyping --nolegend'
  alias ping_='/sbin/ping'
  alias top='btm'
  alias top_='/usr/bin/top'
  alias sed="gsed"
  alias sed_="/usr/bin/sed"
  eval "$(zoxide init zsh --cmd cd)"
fi

# GNU tools
alias md5sum='md5 -r'
alias sha256sum="shasum -a 256"

# Vim
alias n="nvim -c 'Telescope oldfiles'"
alias nvim_="/opt/homebrew/bin/nvim"
alias neovide='/Applications/Neovide.app/Contents/MacOS/neovide'
alias vim_="/usr/bin/vim"
alias vim="nvim"
alias vimdiff="nvim -d"

nvim() {
    if [[ $@ == "." ]]; then
        command nvim
    else
        command nvim "$@"
    fi
}

# other
alias cl="clear"
alias kk="clear"
alias kl="clear"
alias df='df -kTh'
alias du='du -kh' # Makes a more readable output
alias echopath='echo -e ${PATH//:/\\n}'
alias echolibpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias h='history'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias t="tmux"
alias ta="tmux attach"
alias untar='tar xvf'
alias watch="watch "
alias which='type -a'
alias sudo='sudo ' # Enable aliases to be sudo’ed

# typos
alias g='git'
alias it='git'
alias gi='git'
alias gti='git'
alias tit='git'
alias sl='ls'

# ---------
# Functions

exportpathhere() { export PATH=$(pwd):$PATH }

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

function printpath() {
  echo $PATH | sed 's/:/\n/g'
}

# ----------
# Networking

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias rallips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# http requests
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

alias httpserver="open http://localhost:8000 && python -m http.server 8000"

# Helpers
port_listening_who() { lsof -i ":$1" | grep LISTEN }

# Determine if we are an SSH connection
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    export IS_SSH=true
    export TMUX=1
else
    case $(ps -o comm= -p $PPID) in
        sshd|*/sshd) IS_SSH=true
    esac
fi
