#!/usr/bin/env zsh

# enable profiling (also uncomment at the end of this file)
# zmodload zsh/zprof

# Ensure predictable environment
setopt interactive_comments
setopt no_nomatch
setopt auto_pushd
setopt pushd_ignore_dups
setopt autocd
setopt extended_glob

# Function to add paths efficiently
prepend_path() {
    export PATH="$1:$PATH"
    # [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

# macOS specific configurations
if [[ $(uname) == "Darwin" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"

    prepend_path "$HOMEBREW_PREFIX/bin"
    prepend_path "$HOMEBREW_PREFIX/sbin"

    # GNU tools
    prepend_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    prepend_path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
    prepend_path "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
    prepend_path "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"

    # kegonly brew formulas
    prepend_path "/usr/local/opt/curl/bin"
    prepend_path "/opt/homebrew/opt/libpq/bin"

    # Git and GPG config
    export GPG_TTY="$TTY"

    # Disable Homebrew auto updates for speed
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_INSTALL_CLEANUP=1
fi

# Keybindings
bindkey -e   # Emacs keybindings
bindkey "^[[3~" delete-char  # Fix delete key misconfig

# Optimized Completion Configuration
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

autoload -Uz compinit
if [[ ! -f ~/.zcompdump ]] || [[ $(find ~/.zcompdump -mtime +7) ]]; then
  compinit -C
  touch ~/.zcompdump
else
  compinit -d ~/.zcompdump
fi

# History Configuration
HISTSIZE=1000000000
HISTFILE=~/.zsh_history
SAVEHIST="$HISTSIZE"
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups globdots

# fzf
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
fi

# Atuin
if command -v atuin &>/dev/null; then
  source <(atuin init zsh --disable-up-arrow)
fi

# Alias Expansion
typeset -a ealiases
ealiases=()

ealias() { alias "$1"; ealiases+=("${1%%\=*}"); }

expand-ealias() {
  if [[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)ealiases})\$" ]]; then
      zle _expand_alias
      zle expand-word
  fi
  zle magic-space
}
zle -N expand-ealias

bindkey -M viins ' ' expand-ealias
bindkey -M emacs ' ' expand-ealias

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Project Switcher
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
prepend_path "$HOME/.tmux/plugins/tmuxifier/bin"
export TMUXIFIER_LAYOUT_PATH=$HOME/.config/tmux/layouts

# Set default config directory
export XDG_CONFIG_HOME=$HOME/.config

# Local binaries
export PATH="$HOME/.local/bin:$HOME/.local/scripts:$PATH"

# Cargo binaries
export PATH="$HOME/.cargo/bin:$PATH"

# Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

if command -v eza &>/dev/null; then
  alias ls='eza'
fi

alias l='ls'
alias ll='ls -la'
alias la='ls -la'
alias lt='ls --tree'

# macOS specific aliases
if [[ $(uname) == "Darwin" ]]; then
  alias grep='rg'
  alias md5sum='md5 -r'
  alias sha256sum="shasum -a 256"
  alias rm="/opt/homebrew/opt/trash-cli/bin/trash"
fi

# git
alias g='git'
alias it='git'
alias gi='git'
alias gti='git'
alias tit='git'
alias gc='git commit '
alias gp='git push '

# Other
alias cl="clear"
alias clera='clear'
alias kk="clear"
alias kl="clear"
alias df='df -kTh'
alias du='du -kh' # Makes a more readable output
alias echopath='echo -e ${PATH//:/\\n}'
alias echolibpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias h='history'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias sl='ls'
alias t="tmux"
alias ta="tmux attach"
alias tf="terraform"
alias untar='tar xvf'
alias watch="watch "
alias which='type -a'
alias sudo='sudo ' # Enable aliases to be sudo’ed

# Neovim
alias n="nvim -c 'Telescope oldfiles'"
alias vim_="/usr/bin/vim"
alias vim="nvim"
alias vimdiff="nvim -d"

nvim() { [[ $1 == "." ]] && command nvim || command nvim "$@"; }

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

# ---------------------------
# FUNCTIONS
# ---------------------------

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

# ---------------------------
# NETWORKING
# ---------------------------

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

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

# ---------------------------
# DOCKER
# ---------------------------

docker-rm-all() { docker rm -f $(docker ps -a -q) }
docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() { docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
alias docker-rmi-empty='docker rmi $(docker images -f "dangling=true" -q)'
docker-rmi-prefix () { docker rmi -f $(docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}') }
docker-rmi-all () { docker rmi -f $(docker images --format '{{.ID}}') }

# ---------------------------
# Kubernetes
# ---------------------------




if command -v kubectl &>/dev/null; then
    # Source kubectl completion
    source <(kubectl completion zsh)

    k() {
        kubectl "$@"
        # the --namespace flag breaks completions :(
        # if [ -n "$KUBE_NAMESPACE" ]; then
        #     kubectl --namespace "$KUBE_NAMESPACE" "$@"
        # else
        #     kubectl "$@"
        # fi
    }

    compdef _kubectl k
    compdef _kubectl kubecolor

    # Now define other kubectl-related aliases
    ealias kg='k get '
    ealias kl='k logs'
    ealias kgp='k get po '
    ealias kgn='k get no '
    ealias kgd='k get deploy '
    ealias krmp='k delete po '
    ealias kdp='k describe po '
    ealias uek='unset KUBECONFIG'
    ealias uekns='unset KUBE_NAMESPACE'

    # Backup and remove/symlink ~/.kube/config
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
    # echo "Set namespace to $KUBE_NAMESPACE"

    # Ideally we wouldnt do this and just do it with --namepace in kubectl but that breaks tab complete :(
    kubectl config set-context --current --namespace="$KUBE_NAMESPACE"
    echo "Set namespace to $namespace in config: ${KUBECONFIG:-~/.kube/config}"
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

# ---------------------------
# PYTHON
# ---------------------------

export HATCH_CONFIG="$HOME/.config/hatch/config.toml"
export UV_PYTHON_PREFERENCE=only-managed

function pyclean() {
    find . -type f -name '*.py[co]' -delete
    find . -type d -name __pycache__ -exec rm -rf {} +
    find . -type d -name dist -exec rm -rf {} +
    find . -type d -name .ipynb_checkpoints -exec rm -rf {} +
    find . -type d -name .pytest_cache -exec rm -rf {} +
    find . -type d -name .venv -exec rm -rf {} +
}

# disables virtual_env/bin/activate prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Micromamba
if [ -f "$HOME/.local/bin/micromamba" ]; then
    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'micromamba shell init' !!
    export MAMBA_EXE="$HOME/.local/bin/micromamba";
    export MAMBA_ROOT_PREFIX="$HOME/micromamba";
    __mamba_setup="$($HOME/.local/bin/micromamba 'shell' 'hook' '--shell' 'zsh' '--root-prefix' "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        # Fallback on help from micromamba activate
        alias micromamba="$MAMBA_EXE"
    fi
    alias mamba=micromamba
    alias conda=micromamba
    unset __mamba_setup
    # <<< mamba initialize <<<
fi

# Conda
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

# export PATH="$HOME/.pixi/bin:$PATH"

# ---------------------------
# JAVASCRIPT
# ---------------------------

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
# # bun completions
# [ -s "/Users/danrodriguez/.bun/_bun" ] && source "/Users/danrodriguez/.bun/_bun"

alias npmreset="rm -rf node_modules"

export ASTRO_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DEBUG=1.
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

# ---------------------------
# C/C++
# ---------------------------

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# ---------------------------
# GO
# ---------------------------

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

# ---------------------------
# RUST
# ---------------------------

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# ---------------------------
# JAVA
# ---------------------------

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# enable profiling  (also uncomment at the begining of this file)
# zprof
