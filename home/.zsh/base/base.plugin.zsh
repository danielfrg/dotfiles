#!/usr/bin/env zsh

# Ensure predictable environment
setopt interactive_comments
setopt no_nomatch
setopt auto_pushd
setopt pushd_ignore_dups
setopt autocd
setopt correct
setopt extended_glob

# macOS specific configurations
if [[ $(uname) == "Darwin" ]]; then
    # Pasted here explicitly for faster startup
    # Start: eval $($brew_path/brew shellenv)
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}"
    export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
    # End manual brew path

    # GNU tools
    export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"

    # kegonly brew formulas
    export PATH="/usr/local/opt/curl/bin:$PATH"
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

    # Git and GPG config
    export GPG_TTY="$TTY"
fi

# Enable emacs keybindings in tmux
bindkey -e

# Force delete to be delete-char
# (Sometimes this is misconfigured)
bindkey "^[[3~" delete-char

# Project sessions

# Project Switcher Function
project_switcher() {
  selected=$(find_ ~/code ~/code/danielfrg ~/code/inmatura ~/nvidia -mindepth 1 -maxdepth 1 -type d | fzf)

  if [[ -z $selected ]]; then
      exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)

  echo "cd $selected"
  cd "$selected"
}

zle -N project_switcher{,}

alias cdc='project-session.sh'
# ctrl-f for tmux-sessionizer
bindkey -s "^F" "project-session.sh\n"

# Add tmuxifier to the path
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmux/layouts"

# Set default config directory
export XDG_CONFIG_HOME="$HOME/.config"

# Local binaries
export PATH="$HOME/.local/bin:$HOME/.local/scripts:$PATH"

# Cargo binaries
export PATH="$HOME/.cargo/bin:$PATH"

# =========================
# Completion Configuration
# =========================

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

eval "$(fzf --zsh)"

# =========================
# History Configuration
# =========================

HISTSIZE=1000000000
HISTFILE=~/.zsh_history
SAVEHIST="$HISTSIZE"
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots

# Atuin
local FOUND_ATUIN=$+commands[atuin]
if [[ $FOUND_ATUIN -eq 1 ]]; then
  source <(atuin init zsh --disable-up-arrow)
fi

# =========================
# Expand aliases core
# =========================
typeset -a ealiases
ealiases=()

function ealias()
{
  alias $1
  ealiases+=(${1%%\=*})
}

function expand-ealias()
{
if [[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)ealiases})\$" ]]; then
    zle _expand_alias
    zle expand-word
fi
zle magic-space
}

zle -N expand-ealias

bindkey -M viins ' '    expand-ealias
bindkey -M emacs ' '    expand-ealias
bindkey -M viins '^ '   magic-space     # control-space to bypass completion
bindkey -M emacs '^ '   magic-space
bindkey -M isearch ' '  magic-space # normal space during searches


# =========================
# ALIASES
# =========================

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

if command -v eza > /dev/null 2>&1; then
  alias ls='eza'
fi
alias l='ls'
alias ll='ls -la'
alias la='ls -la'
alias lt='ls --tree'

# Other
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

# git
alias g='git'
alias it='git'
alias gi='git'
alias gti='git'
alias tit='git'
alias gc='git commit '
alias gp='git push '

alias sl='ls'
alias clera='clear'

# macOS specific aliases
if [[ $(uname) == "Darwin" ]]; then
  alias cat='bat --style="header"'
  alias cat_='/bin/cat'
  alias grep='rg'
  alias grep_='/usr/bin/grep -i --color=always'
  alias ping='prettyping --nolegend'
  alias ping_='/sbin/ping'
  alias top='btm'
  alias top_='/usr/bin/top'

  # GNU tools
  alias sed="gsed"
  alias sed_="/usr/bin/sed"
  alias md5sum='md5 -r'
  alias sha256sum="shasum -a 256"

  # Safer removal using trash
  alias rm_="/bin/rm"
  alias rm="trash"
fi

# =========================
# NEOVIM
# =========================

alias n="nvim -c 'Telescope oldfiles'"
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

# Yazi
local FOUND_YAZI=$+commands[yazi]
if [[ $FOUND_YAZI -eq 1 ]]; then
  function yy() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
  }
fi

# =========================
# FUNCTIONS
# =========================

exportpathhere() { export PATH="$(pwd):$PATH" }

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_"
}

function search() {
  if [ $# -ne 2 ]; then
    echo "Arguments: path pattern"
  else
    grep -rnw "$1" -e "$2"
  fi
}

# Determine size of a file or total size of a directory
function dirsize() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$@" ]]; then
    du "$arg" -- "$@";
  else
    du "$arg" .[^.]* *;
  fi;
}

function clipvideo() {
  if [ $# -ne 4 ]; then
    echo "Arguments: <input> <start> <end> <output>"
  else
    ffmpeg -i "$1" -ss "$2" -to "$3" -c:v copy -c:a copy "$4"
  fi
}

function printpath() {
  echo "$PATH" | sed 's/:/\n/g'
}

# =========================
# NETWORKING
# =========================

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias rallips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# HTTP requests
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

alias httpserver="open http://localhost:8000 && python -m http.server 8000"

# Helpers
port_listening_who() { lsof -i ":$1" | grep LISTEN }

# Determine if we are an SSH connection
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    export IS_SSH=1
else
    case $(ps -o comm= -p "$PPID") in
        sshd|*/sshd) IS_SSH=true
    esac
fi


# =========================
# DOCKER
# =========================

docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() { docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
alias docker-rmi-empty='docker rmi $(docker images -f "dangling=true" -q)'
docker-rmi-prefix () { docker rmi -f $(docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}') }
docker-rmi-all () { docker rmi -f $(docker images --format '{{.ID}}') }

# =========================
# Kubernetes
# =========================

ealias kg='k get '
ealias kl='k logs'
ealias kgp='k get po '
ealias kgn='k get no '
ealias kgd='k get deploy '
ealias krmp='k delete po '
ealias kdp='k describe po '
ealias uek='unset KUBECONFIG'
ealias uekns='unset KUBE_NAMESPACE'


alias tf="terraform"

# Check if kubectl exists
if type kubectl >/dev/null 2>&1; then
    if type kubectl >/dev/null 2>&1; then
        alias kubectl=kubecolor
    fi

    # Source kubectl completion *before* aliasing
    source <(kubectl completion zsh)

    # Function k
    k() {
        if [ -n "$KUBE_NAMESPACE" ]; then
            kubectl --namespace "$KUBE_NAMESPACE" "$@"
        else
            kubectl "$@"
        fi
    }

    compdef _kubectl k
    compdef _kubectl kubecolor

    # Backup and remove/symlink ~/.kube/config (this part is unrelated to completion)
    if [[ -f ~/.kube/config && ! -L ~/.kube/config ]]; then
        mv ~/.kube/config ~/.kube/config.backup_$(date +%Y%m%d_%H%M%S)
        echo "Existing ~/.kube/config backed up."
    fi

    # Remove default kubeconfig
    ln -sf /dev/null ~/.kube/config
fi

# export kubeconfig
# From: https://gist.github.com/rothgar/a2092f73b06465ddda0e855cc1f6ec2b
ek() {
    if [ -n "$1" ]; then
        CONFIG=$(rg --max-depth 3 -l '^kind: Config$' "$HOME/.kube/" 2>/dev/null \
            | grep "$1")
    else
        CONFIG=$(rg --max-depth 3 -l '^kind: Config$' "$HOME/.kube/" "$PWD" 2>/dev/null | fzf --multi | tr '\n' ':')
    fi
    # echo file and remove trailing :
    echo "${CONFIG%:*}"
    export KUBECONFIG="${CONFIG%:*}"
    # PROFILE=$(yq '.users[0].user.exec.env[0].value' $KUBECONFIG)
    # REGION=$(yq '.users[0].user.exec.args' $KUBECONFIG | grep -A1 region | tail -1 | awk '{print $2}')
    # awsp $PROFILE $REGION
}

# helper for setting a namespace
# List namespaces, preview the pods within, and save as variable
function ekns() {
  namespaces=$(kubectl get ns -o=custom-columns=:.metadata.name)
  export KUBE_NAMESPACE=$(echo $namespaces | fzf --select-1 --preview "kubectl --namespace {} get pods")
  echo "Set namespace to $KUBE_NAMESPACE"
}

k_logs_deploy() {
  if [ -n "$1" ]; then
    kubectl logs $(kubectl get pods -l app="$1" -o jsonpath="{.items[*].metadata.name}")
  fi
}

k_delete_deployment_pods() {
  if [ -n "$1" ]; then
    kubectl delete pod $(kubectl get pods -l app="$1" -o jsonpath="{.items[*].metadata.name}")
  fi
}

kubedecode() {
    if [ $# -ne 2 ]; then
        echo "Arguments: secret_name key"
    else
        kubectl get secret "$1" -o json | jq -r ".[\"data\"][\"$2\"]" | base64 --decode
    fi
}

kexec() {
    if [ $# -ne 1 ]; then
        echo "Arguments: pod_name"
    else
        kubectl exec -it "$1" -- bash
    fi
}

# =========================
# PYTHON
# =========================

export PATH="$HOME/.pixi/bin:$PATH"

export HATCH_CONFIG="$HOME/.config/hatch/config.toml"

function pyclean() {
    find_ . -type f -name '*.py[co]' -delete
    find_ . -type d -name __pycache__ -exec rm -rf {} +
    find_ . -type d -name dist -exec rm -rf {} +
    find_ . -type d -name .ipynb_checkpoints -exec rm -rf {} +
    find_ . -type d -name .pytest_cache -exec rm -rf {} +
    find_ . -type d -name .venv -exec rm -rf {} +
}

# disables virtual_env/bin/activate prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Micromamba optional stuff
if [ -f "$HOME/.local/bin/micromamba" ]; then
    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'micromamba shell init' !!
    export MAMBA_EXE="$HOME/.local/bin/micromamba";
    export MAMBA_ROOT_PREFIX="$HOME/micromamba";
    __mamba_setup="$($HOME/.local/bin/micromamba 'shell' 'hook' '--shell' 'zsh' '--root-prefix' "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
        alias mamba=micromamba
    else
        # Fallback on help from micromamba activate
        alias micromamba="$MAMBA_EXE"
        alias mamba=micromamba
    fi
    unset __mamba_setup
    # <<< mamba initialize <<<
fi


# Conda optional stuff
if [ -d "$HOME/conda" ]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('$HOME/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/conda/etc/profile.d/conda.sh" ]; then
            . "$HOME/conda/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/conda/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi

# =========================
# JAVASCRIPT
# =========================

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun completions
[ -s "/Users/danrodriguez/.bun/_bun" ] && source "/Users/danrodriguez/.bun/_bun"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# if [[ -z $PNPM_COMPLETE ]]
# then
#     source <(command pnpm completion zsh)
#     PNPM_COMPLETE=1
# fi

alias npmreset="rm -rf node_modules"

export ASTRO_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DEBUG=1.
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

# =========================
# C/C++
# =========================

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# =========================
# GO
# =========================

export GOPATH=~/go
export GOBIN=~/go/bin
export PATH="$GOPATH/bin:$PATH"
export GO111MODULE=on

goinstalltools() {
    # local old_path=$PATH
    # local old_go_path=$GOPATH
    # export GOPATH=$tools_dir
    go get -v -u golang.org/x/lint/golint
    go install -v github.com/incu6us/goimports-reviser/v3@latest
    go install github.com/segmentio/golines@latest
    # export PATH=$old_path
    # export GOPATH=$old_go_path
}

# =========================
# RUST
# =========================

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# =========================
# JAVA
# =========================

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"



ealias g="git"
