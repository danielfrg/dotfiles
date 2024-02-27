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
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

    # Completitions
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"

    # Git and GPG config
    export GPG_TTY=$TTY

    alias rm_="/bin/rm"
    alias rm="trash"

    # zoxide only on laptop
    alias cd='z'

    # Lock the screen (when going AFK)
    alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
else
    # echo 'Unknown OS!'
fi

# Local binaries
export PATH=$HOME/.local/bin:$HOME/.local/scripts:$PATH

# Cargo binaries
export PATH=$HOME/.cargo/bin:$PATH

# Prompt

# Start precmd functions
typeset -a precmd_functions
autoload -U colors && colors

ZSH_THEME_GIT_PROMPT_PREFIX="on %{$fg[blue]%}git%{$reset_color%}:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_BRANCH=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]?%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[cyan]%}%{+%G%}"

ZSH_THEME_VIRTUALENV_PREFIX="%{$fg[green]%}  "
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"

# This is the basic prompt that is always printed.  It will be
# enclosed to make it newline.
# USER=asdf
# SSH_CLIENT=1
_USER_PROMPT=$(if [[ $USER != "danielfrg" ]]; then echo '%F{magenta}%n%f at '; else echo ""; fi)
_HOST_PROMPT=$(if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then echo '%F{yellow}%m%f at '; else echo ""; fi)
_BASE_PROMPT=$_USER_PROMPT$_HOST_PROMPT'%F{blue}%~%f'

# This is the base prompt that is rendered sync.  It should be
# fast to render as a result.  The extra whitespace before the
# newline is necessary to avoid some rendering bugs.
PROMPT=$'\n'$_BASE_PROMPT$' \n$ '
RPROMPT='%*'

_MITSUHIKO_ASYNC_PROMPT=0
_MITSUHIKO_ASYNC_PROMPT_FN="/tmp/.zsh_tmp_prompt_$$"

function _mitsuhiko_precmd() {
  _mitsuhiko_rv=$?

  function async_prompt() {
    # echo -n $(virtualenv_prompt_info) > $_MITSUHIKO_ASYNC_PROMPT_FN
    # export PY_VENV=$(virtualenv_prompt_info)

    echo -n $'\n'$_BASE_PROMPT$' '$(git_prompt_info)$(virtualenv_prompt_info) > $_MITSUHIKO_ASYNC_PROMPT_FN
    if [[ x$_mitsuhiko_rv != x0 ]]; then
      echo -n " exited %{$fg[red]%}$_mitsuhiko_rv%{$reset_color%}" >> $_MITSUHIKO_ASYNC_PROMPT_FN
    fi
    echo -n $' \n$ ' >> $_MITSUHIKO_ASYNC_PROMPT_FN

    # signal parent
    kill -s USR1 $$
  }

  # If we still have a prompt async process we kill it to make sure
  # we do not backlog with useless prompt things.  This also makes
  # sure that we do not have prompts interleave in the tempfile.
  if [[ "${_MITSUHIKO_ASYNC_PROMPT}" != 0 ]]; then
    kill -s HUP $_MITSUHIKO_ASYNC_PROMPT >/dev/null 2>&1 || :
  fi

  # start background computation
  async_prompt &!
  _MITSUHIKO_ASYNC_PROMPT=$!
}

# This is the trap for the signal that updates our prompt and
# redraws it.  We intentionally do not delete the tempfile here
# so that we can reuse the last prompt for successive commands
function _mitsuhiko_trapusr1() {
  PROMPT="$(cat $_MITSUHIKO_ASYNC_PROMPT_FN)"
  _MITSUHIKO_ASYNC_PROMPT=0
  zle && zle reset-prompt
}

# Make sure we clean up our tempfile on exit
function _mitsuhiko_zshexit() {
  /bin/rm -f $_MITSUHIKO_ASYNC_PROMPT_FN
}

# Hook our precmd and zshexit functions and USR1 trap
precmd_functions+=(_mitsuhiko_precmd)
zshexit_functions+=(_mitsuhiko_zshexit)
trap '_mitsuhiko_trapusr1' USR1
# -----------------


# History base
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoredups:ignorespace
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

# History Atuin
local FOUND_ATUIN=$+commands[atuin]
if [[ $FOUND_ATUIN -eq 1 ]]; then
  source <(atuin init zsh --disable-up-arrow)
fi

#########################
# ALIASES
#########################

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Files
alias l='ls'
alias ll='ls -la'
alias la='ls -la'
alias lt='ls --tree'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias cl="clear"
alias kk="clear"
alias kl="clear"

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
project_switcher() {
  selected=$(find_ ~/code ~/code/danielfrg ~/code/inmatura ~/google -mindepth 1 -maxdepth 1 -type d | fzf)

  if [[ -z $selected ]]; then
      exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)

  echo "cd $selected"
  cd $selected
}

zle -N project_switcher{,}
bindkey -s ^f "tmux-sessionizer\n"

# bindkey -s ^t "tmux-sessionizer\n"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cdc='tmux-sessionizer'
# alias cdc='project_switcher'
alias cdd="cd ~/Downloads"
alias t="tmux"
alias ta="tmux attach"

# Typos
alias g='git'
alias it='git'
alias gi='git'
alias gti='git'
alias tit='git'
alias sl='ls'

# untar
alias untar='tar xvf'

# GNU tools
alias sed_="/usr/bin/sed"
alias sed="gsed"

# NeoVim
alias vim_="/usr/bin/vim"
alias nvim_="/opt/homebrew/bin/nvim"

nvim() {
    if [[ $@ == "." ]]; then
        command nvim
    else
        command nvim "$@"
    fi
}
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias "vim ."="nvim"
alias c="nvim"
alias vimdiff="nvim -d"

# Fancy replacements for common commands
# From: https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/

if [[ $+commands[exa] -eq 1 ]]; then
  alias ls='exa --icons --group-directories-first'
  alias ls_='/bin/ls'
fi

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
alias kgp="kubectl get pod"
alias kubecl='kubectl'
alias kubect='kubectl'
alias kubelt='kubectl'
alias kubeclt='kubectl'
alias kuebctl='kubectl'
alias kns='kubens'
alias kctx='kubectx'
alias terrafrom='terraform'
alias tf='terraform'

k_logs_deploy() {
  if [ -n "$1" ]
  then
    kubectl logs $(kubectl get pods -l app=$1 -o jsonpath="{.items[*].metadata.name}")
  fi
}

k_delete_deployment_pods() {
  if [ -n "$1" ]
  then
    kubectl delete pod $(kubectl get pods -l app=$1 -o jsonpath="{.items[*].metadata.name}")
  fi
}

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
