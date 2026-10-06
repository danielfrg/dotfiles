#!/usr/bin/env zsh

# Keep interactive behavior predictable.
setopt interactive_comments
setopt no_nomatch
setopt auto_pushd
setopt pushd_ignore_dups
setopt autocd
setopt extended_glob
setopt aliases

# Keep PATH entries unique while preserving their first occurrence.
typeset -gU path PATH

prepend_path() {
    [[ -d "$1" ]] || return 0
    path=("$1" $path)
}

append_path() {
    [[ -d "$1" ]] || return 0
    path+=("$1")
}

# -----------------------------------------------
# Environment and PATH

if [[ $OSTYPE == darwin* ]]; then
    # Configure Homebrew directly instead of spawning `brew shellenv` for every
    # interactive shell. Keep this in .zshrc so login and tmux shells agree.
    if [[ -d /opt/homebrew ]]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
        export HOMEBREW_REPOSITORY="/opt/homebrew"
    elif [[ -d /usr/local/Homebrew ]]; then
        export HOMEBREW_PREFIX="/usr/local"
        export HOMEBREW_CELLAR="/usr/local/Cellar"
        export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
    fi

    if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
        prepend_path "$HOMEBREW_PREFIX/sbin"
        prepend_path "$HOMEBREW_PREFIX/bin"
        if [[ ":${INFOPATH:-}:" != *":$HOMEBREW_PREFIX/share/info:"* ]]; then
            export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
        fi

        prepend_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
        prepend_path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
        prepend_path "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
        prepend_path "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
        prepend_path "$HOMEBREW_PREFIX/opt/curl/bin"
        prepend_path "$HOMEBREW_PREFIX/opt/libpq/bin"
    fi

    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    if [[ -t 0 ]]; then
        export GPG_TTY="$(tty)"
    fi

    # This is the locale spelling available on macOS. Do not inherit the
    # invalid en_US.utf8 value previously set by Nushell.
    export LANG="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
    unset LC_ALL
fi

# Nix multi-user installation. The canonical script sets PATH, NIX_PROFILES,
# XDG_DATA_DIRS, and the CA bundle while avoiding duplicate initialization.
if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

export EDITOR="nvim"
export VISUAL="$EDITOR"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# User paths, ordered from highest to lowest priority. Missing optional tools
# are ignored so the same config works on new machines.
typeset -a _user_paths
_user_paths=(
    "$HOME/.local/bin"
    "$HOME/.local/scripts"
    "$HOME/.things/bin"
    "$HOME/.cargo/bin"
    "$HOME/.opencode/bin"
    "$HOME/.pixi/bin"
    "$HOME/conda/bin"
    "$HOME/.bun/bin"
    "$HOME/.vite-plus/bin"
    "$HOME/.lmstudio/bin"
    "$HOME/.config/herd-lite/bin"
    "$HOME/.orbstack/bin"
    "$HOME/.tmux/plugins/tmuxifier/bin"
)
for (( _path_index=${#_user_paths}; _path_index >= 1; _path_index-- )); do
    prepend_path "${_user_paths[_path_index]}"
done
unset _user_paths _path_index

if [[ -d "$HOME/.config/herd-lite/bin" ]]; then
    export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin${PHP_INI_SCAN_DIR:+:$PHP_INI_SCAN_DIR}"
fi

export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmux/layouts"

# -----------------------------------------------
# Keybindings, completion, and history

bindkey -e
bindkey '^[[3~' delete-char

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

HISTSIZE=50000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups
setopt hist_save_no_dups hist_ignore_dups hist_find_no_dups globdots

# -----------------------------------------------
# Abbreviations

typeset -ga ealiases
ealiases=()

abbr() {
    if (( $# != 1 )); then
        print -u2 'Usage: abbr name=value'
        return 1
    fi
    alias "$1"
    ealiases+=("${1%%=*}")
}

expand-ealias() {
    local last_word=${LBUFFER##* }
    local abbreviation

    for abbreviation in "${ealiases[@]}"; do
        if [[ $last_word == "$abbreviation" ]]; then
            zle _expand_alias
            zle expand-word
            break
        fi
    done
    zle magic-space
}
zle -N expand-ealias

# Space expands registered abbreviations; Ctrl-Space inserts a literal space.
bindkey ' ' expand-ealias
bindkey '^ ' magic-space
bindkey -M isearch ' ' magic-space

# -----------------------------------------------
# Tool integrations

ZSH_INIT_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init"
if [[ ! -d "$ZSH_INIT_CACHE_DIR" ]]; then
    command mkdir -p "$ZSH_INIT_CACHE_DIR"
fi

# Cache generated shell code and refresh it automatically when its executable
# is upgraded. Generation is atomic so a failed command never leaves a partial
# script behind; an older valid cache remains usable on transient failures.
_cache_zsh_init() {
    local cache_name=$1 generator=$2
    shift 2

    local cache_file="$ZSH_INIT_CACHE_DIR/$cache_name.zsh"
    local temp_file="$cache_file.tmp.$$"

    if [[ ! -s "$cache_file" || "$generator" -nt "$cache_file" ]]; then
        if "$generator" "$@" >| "$temp_file"; then
            /bin/mv -f "$temp_file" "$cache_file"
        else
            /bin/rm -f "$temp_file"
            if [[ ! -s "$cache_file" ]]; then
                print -u2 "Unable to initialize $cache_name."
                return 1
            fi
            print -u2 "Warning: using the previous $cache_name cache."
        fi
    fi

    source "$cache_file"
}

refresh-zsh-init-cache() {
    local -a cache_files
    cache_files=("$ZSH_INIT_CACHE_DIR"/*.zsh(N))
    (( ${#cache_files} )) && /bin/rm -f -- "${cache_files[@]}"
    print 'Generated shell init caches cleared. Start a new Zsh to rebuild them.'
}

if (( $+commands[fzf] )); then
    _cache_zsh_init fzf-zsh-v1 "${commands[fzf]}" --zsh
fi

if (( $+commands[zoxide] )); then
    _cache_zsh_init zoxide-zsh-v1 "${commands[zoxide]}" init zsh
fi

if [[ -f "$HOME/.local/scripts/git-worktree.sh" ]]; then
    source "$HOME/.local/scripts/git-worktree.sh"
fi

if (( $+commands[atuin] )); then
    _cache_zsh_init atuin-zsh-no-up-arrow-v1 "${commands[atuin]}" init zsh --disable-up-arrow
fi

if (( $+commands[direnv] )); then
    _cache_zsh_init direnv-zsh-v1 "${commands[direnv]}" hook zsh
fi

# -----------------------------------------------
# Project/session switching

project_switcher() {
    local selected root output
    local -a roots candidates

    for root in "$HOME/code" "$HOME/code/danielfrg" "$HOME/code/inmatura" "$HOME/code/nvidia"; do
        [[ -d "$root" ]] && roots+=("$root")
    done

    (( ${#roots} )) || {
        print -u2 'No project directories found.'
        return 1
    }

    output=$(find "${roots[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort -u)
    [[ -n $output ]] || {
        print -u2 'No projects found.'
        return 1
    }
    candidates=("${(@f)output}")

    selected=$(printf '%s\n' "${candidates[@]}" | fzf) || return 0
    [[ -n $selected ]] || return 0
    builtin cd -- "$selected"
}
zle -N project_switcher

project_session_widget() {
    zle -I
    "$HOME/.local/scripts/project-session.sh"
    zle reset-prompt
}
zle -N project_session_widget
bindkey '^F' project_session_widget

alias cdc="$HOME/.local/scripts/project-session.sh"

rgf() {
    local file
    file=$(rg --files-with-matches --hidden --glob '!.git' -- "$1" \
        | fzf --preview 'bat --color=always --style=numbers --line-range :500 {}') || return 0
    [[ -n $file ]] && nvim "$file"
}

# -----------------------------------------------
# Aliases

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
abbr cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

if (( $+commands[eza] )); then
    alias ls='eza'
fi

alias l='ls'
alias ll='ls -la'
alias la='ls -la'
alias lt='ls --tree'

if [[ $OSTYPE == darwin* ]]; then
    alias md5sum='md5 -r'
    alias sha256sum='shasum -a 256'
    if [[ -x ${HOMEBREW_PREFIX:-/opt/homebrew}/opt/trash-cli/bin/trash ]]; then
        alias rm="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/trash-cli/bin/trash"
    fi
fi

# Git
abbr g='git'
abbr it='git'
abbr gi='git'
abbr gti='git'
abbr tit='git'
abbr gc='git commit '
abbr gp='git push '

# Other
abbr cl='clear'
abbr clera='clear'
abbr kk='clear'
abbr kl='clear'
abbr df='df -kTh'
abbr du='du -sh'
abbr echopath='echo -e ${PATH//:/\\n}'
abbr echolibpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
abbr preview="fzf --preview 'bat --color \"always\" {}'"
abbr sl='ls'
abbr t='tmux'
abbr ta='tmux attach'
abbr tf='terraform'
abbr untar='tar xvf'
alias sudo='sudo '

# Neovim
alias vim='nvim'
alias vim_='/usr/bin/vim'
abbr vimdiff='nvim -d'

# Yazi
if (( $+commands[yazi] )); then
    yy() {
        local tmp cwd
        tmp=$(mktemp -t 'yazi-cwd.XXXXXX') || return 1
        yazi "$@" --cwd-file="$tmp"
        if cwd=$(<"$tmp") && [[ -n $cwd && $cwd != $PWD ]]; then
            builtin cd -- "$cwd"
        fi
        /bin/rm -f -- "$tmp"
    }
fi

# -----------------------------------------------
# General helpers

addpwdtopath() {
    prepend_path "$PWD"
}

search() {
    if (( $# != 2 )); then
        print -u2 'Usage: search <path> <pattern>'
        return 1
    fi
    grep -rnw "$1" -e "$2"
}

dirsize() {
    if (( $# )); then
        du -sh -- "$@"
    else
        du -sh -- .[^.]* * 2>/dev/null
    fi
}

clipvideo() {
    if (( $# != 4 )); then
        print -u2 'Usage: clipvideo <input> <start> <end> <output>'
        return 1
    fi
    ffmpeg -i "$1" -ss "$2" -to "$3" -c:v copy -c:a copy "$4"
}

# -----------------------------------------------
# Networking

alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]))"'

for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done
unset method

alias httpserver='open http://localhost:8000 && python3 -m http.server 8000'
port_listening_who() { lsof -i ":$1" | grep LISTEN }

if [[ -n ${SSH_CLIENT:-} || -n ${SSH_TTY:-} ]]; then
    export IS_SSH=1
else
    case $(ps -o comm= -p "$PPID") in
        sshd|*/sshd) export IS_SSH=1 ;;
    esac
fi

# -----------------------------------------------
# Cleanup helpers

_cleanup_size_kib() {
    local item size
    local -i total=0

    for item in "$@"; do
        size=$(/usr/bin/du -sk "$item" 2>/dev/null | awk 'NR == 1 { print $1 }')
        (( total += ${size:-0} ))
    done
    print -r -- "$total"
}

_format_kib() {
    awk -v kib="$1" 'BEGIN {
        if (kib >= 1048576) printf "%.2f GiB", kib / 1048576;
        else if (kib >= 1024) printf "%.2f MiB", kib / 1024;
        else printf "%d KiB", kib;
    }'
}

py-clean() {
    local target='.' arg item resolved_target home_root
    local -i execute=0 target_set=0 removed=0 failed=0
    local -a matches

    for arg in "$@"; do
        case $arg in
            -d|--dry-run) execute=0 ;;
            -f|--force) execute=1 ;;
            -*) print -u2 "Unknown option: $arg"; return 2 ;;
            *)
                (( target_set )) && { print -u2 'Only one target directory is supported.'; return 2; }
                target=$arg
                target_set=1
                ;;
        esac
    done

    [[ -d $target ]] || { print -u2 "Not a directory: $target"; return 1; }
    resolved_target=${target:A}
    home_root=${HOME:A}
    if [[ $resolved_target == / || $resolved_target == "$home_root" || $resolved_target == /Users || $resolved_target == /home ]]; then
        print -u2 "Refusing to clean broad target: $resolved_target"
        return 1
    fi

    while IFS= read -r -d '' item; do
        matches+=("$item")
    done < <(
        find "$resolved_target" \
            \( -type d \( \
                -name __pycache__ -o -name .pytest_cache -o -name .mypy_cache -o \
                -name .ruff_cache -o -name .ipynb_checkpoints -o -name .venv -o \
                -name dist -o -name '*.egg-info' -o -name build -o -name .tox -o -name .nox \
            \) -prune -print0 \) -o \
            \( -type f -name '*.py[co]' -print0 \)
    )

    if (( ! ${#matches} )); then
        print 'Nothing to clean.'
        return 0
    fi

    local total_kib=$(_cleanup_size_kib "${matches[@]}")
    local total_human=$(_format_kib "$total_kib")

    if (( ! execute )); then
        print "Would remove ${#matches} Python artifacts ($total_human):"
        printf '  %s\n' "${matches[@]}"
        print 'Re-run with --force to remove them.'
        return 0
    fi

    for item in "${matches[@]}"; do
        if [[ -d $item ]]; then
            /bin/rm -rf -- "$item"
        else
            /bin/rm -f -- "$item"
        fi
        if (( $? == 0 )); then
            (( ++removed ))
        else
            (( ++failed ))
        fi
    done

    print "Removed $removed Python artifacts, freeing approximately $total_human."
    if (( failed )); then
        print -u2 "Failed to remove $failed Python artifacts."
        return 1
    fi
}

# Backward-compatible spelling.
pyclean() { py-clean "$@" }

node-clean() {
    local target='.' arg item resolved_target home_root
    local -i execute=0 target_set=0 removed=0 failed=0
    local -a matches

    for arg in "$@"; do
        case $arg in
            -d|--dry-run) execute=0 ;;
            -f|--force) execute=1 ;;
            -*) print -u2 "Unknown option: $arg"; return 2 ;;
            *)
                (( target_set )) && { print -u2 'Only one target directory is supported.'; return 2; }
                target=$arg
                target_set=1
                ;;
        esac
    done

    [[ -d $target ]] || { print -u2 "Not a directory: $target"; return 1; }
    resolved_target=${target:A}
    home_root=${HOME:A}
    if [[ $resolved_target == / || $resolved_target == "$home_root" || $resolved_target == /Users || $resolved_target == /home ]]; then
        print -u2 "Refusing to clean broad target: $resolved_target"
        return 1
    fi

    while IFS= read -r -d '' item; do
        matches+=("$item")
    done < <(
        find "$resolved_target" -type d \( \
            -name node_modules -o -name .next -o -name .nuxt -o -name .turbo -o \
            -name .cache -o -name .parcel-cache -o -name .svelte-kit -o -name .output -o \
            -name dist -o -name .vercel \
        \) -prune -print0
    )

    if (( ! ${#matches} )); then
        print 'Nothing to clean.'
        return 0
    fi

    local total_kib=$(_cleanup_size_kib "${matches[@]}")
    local total_human=$(_format_kib "$total_kib")

    if (( ! execute )); then
        print "Would remove ${#matches} JavaScript dependency/cache directories ($total_human):"
        printf '  %s\n' "${matches[@]}"
        print 'Re-run with --force to remove them.'
        return 0
    fi

    for item in "${matches[@]}"; do
        /bin/rm -rf -- "$item"
        if (( $? == 0 )); then
            (( ++removed ))
        else
            (( ++failed ))
        fi
    done

    print "Removed $removed JavaScript directories, freeing approximately $total_human."
    if (( failed )); then
        print -u2 "Failed to remove $failed JavaScript directories."
        return 1
    fi
}

# -----------------------------------------------
# Docker

_docker_ids() {
    local description=$1 output
    shift

    output=$("$@") || return $?
    reply=()
    if [[ -z $output ]]; then
        print "No $description."
        return 0
    fi
    reply=("${(@f)output}")
}

docker-rm-all() {
    local -a reply
    _docker_ids containers docker ps -a -q || return $?
    (( ${#reply} )) || return 0
    docker rm -f -- "${reply[@]}"
}

docker-stop-all() {
    local -a reply
    _docker_ids containers docker ps -a -q || return $?
    (( ${#reply} )) || return 0
    docker stop -- "${reply[@]}"
}

docker-prune() { docker system prune -f }
docker-clean() { docker-stop-all && docker-prune }

docker-rmi-empty() {
    local -a reply
    _docker_ids 'dangling images' docker images -f dangling=true -q || return $?
    (( ${#reply} )) || return 0
    docker rmi -- "${reply[@]}"
}

docker-rmi-prefix() {
    if [[ -z ${1:-} ]]; then
        print -u2 'Usage: docker-rmi-prefix <repository-prefix>'
        return 1
    fi

    local output
    local -a images
    output=$(docker images --filter "reference=$1*" --format '{{.Repository}}:{{.Tag}}') || return $?
    if [[ -z $output ]]; then
        print 'No matching images.'
        return 0
    fi
    images=("${(@f)output}")
    docker rmi -f -- "${images[@]}"
}

docker-rmi-all() {
    local -a reply
    _docker_ids images docker images --format '{{.ID}}' || return $?
    (( ${#reply} )) || return 0
    docker rmi -f -- "${reply[@]}"
}

# -----------------------------------------------
# Kubernetes

if (( $+commands[kubectl] )); then
    _cache_zsh_init kubectl-completion-zsh-v1 "${commands[kubectl]}" completion zsh

    if (( $+commands[kubecolor] )); then
        alias kubectl='kubecolor'
        compdef _kubectl kubecolor
    fi

    abbr k='kubectl '
    abbr kg='kubectl get '
    abbr kl='kubectl logs '
    abbr kgp='kubectl get pods '
    abbr kgn='kubectl get nodes '
    abbr kgd='kubectl get deployments '
    abbr krmp='kubectl delete pod '
    abbr kdp='kubectl describe pod '
    abbr uek='unset KUBECONFIG'
    abbr uekns='unset KUBE_NAMESPACE'
fi

# This policy used to run during every shell startup. It is now explicit.
kube-disable-default-config() {
    local kube_dir="$HOME/.kube"
    local kube_config="$kube_dir/config"
    local backup

    /bin/mkdir -p "$kube_dir" || return 1
    if [[ -L $kube_config && $(readlink "$kube_config") == /dev/null ]]; then
        print '~/.kube/config is already linked to /dev/null.'
        return 0
    fi

    if [[ -e $kube_config || -L $kube_config ]]; then
        backup="$kube_dir/config.backup_$(date +%Y%m%d_%H%M%S)-$$"
        [[ ! -e $backup && ! -L $backup ]] || { print -u2 "Backup already exists: $backup"; return 1; }
        /bin/mv "$kube_config" "$backup" || return 1
        print "Backed up the existing config to $backup"
    fi

    /bin/ln -s /dev/null "$kube_config" || return 1
    print 'Linked ~/.kube/config to /dev/null.'
}

ek() {
    local query=${1:-} config selection output
    local -a configs selected search_roots

    [[ -d "$HOME/.kube" ]] || { print -u2 'No ~/.kube directory found.'; return 1; }
    search_roots=("$HOME/.kube")
    [[ $PWD != "$HOME/.kube"* ]] && search_roots+=("$PWD")

    output=$(rg --max-depth 3 -l '^kind: Config$' "${search_roots[@]}" 2>/dev/null)
    if [[ -z $output ]]; then
        print 'No kubeconfig files found.'
        return 0
    fi
    configs=("${(@fu)output}")

    if [[ -n $query ]]; then
        for config in "${configs[@]}"; do
            [[ $config == *"$query"* ]] && selected+=("$config")
        done
    else
        selection=$(printf '%s\n' "${configs[@]}" | fzf --multi) || return 0
        [[ -n $selection ]] && selected=("${(@f)selection}")
    fi

    if (( ! ${#selected} )); then
        print "No matching kubeconfigs${query:+ for $query}."
        return 0
    fi

    export KUBECONFIG="${(j.:.)selected}"
    print -r -- "$KUBECONFIG"
}

ekns() {
    local namespaces namespace
    namespaces=$(command kubectl get namespaces -o custom-columns=:.metadata.name 2>/dev/null) || {
        print -u2 'Unable to list Kubernetes namespaces.'
        return 1
    }

    namespace=$(printf '%s\n' "$namespaces" \
        | fzf --select-1 --preview 'kubectl --namespace {} get pods') || return 0
    [[ -n $namespace ]] || { print 'No namespace selected.'; return 0; }

    export KUBE_NAMESPACE="$namespace"
    command kubectl config set-context --current --namespace="$namespace" >/dev/null || return 1
    print "Set namespace to $namespace in config: ${KUBECONFIG:-$HOME/.kube/config}"
}

k_logs_deploy() {
    [[ -n ${1:-} ]] || { print -u2 'Usage: k_logs_deploy <app-label>'; return 1; }
    command kubectl logs -l "app=$1"
}

k_delete_deployment_pods() {
    [[ -n ${1:-} ]] || { print -u2 'Usage: k_delete_deployment_pods <app-label>'; return 1; }
    local output
    local -a pods
    output=$(command kubectl get pods -l "app=$1" -o jsonpath='{.items[*].metadata.name}') || return 1
    if [[ -z $output ]]; then
        print 'No matching pods.'
        return 0
    fi
    pods=("${(@z)output}")
    command kubectl delete pod "${pods[@]}"
}

kubedecode() {
    if (( $# != 2 )); then
        print -u2 'Usage: kubedecode <secret-name> <key>'
        return 1
    fi
    command kubectl get secret "$1" -o json | jq -r ".data[\"$2\"]" | base64 --decode
}

kexec() {
    if (( $# != 1 )); then
        print -u2 'Usage: kexec <pod-name>'
        return 1
    fi
    command kubectl exec -it "$1" -- bash
}

# -----------------------------------------------
# Python

export HATCH_CONFIG="$HOME/.config/hatch/config.toml"
export UV_PYTHON_PREFERENCE='only-managed'
export VIRTUAL_ENV_DISABLE_PROMPT=1

if [[ -x "$HOME/.local/bin/micromamba" ]]; then
    export MAMBA_EXE="$HOME/.local/bin/micromamba"
    export MAMBA_ROOT_PREFIX="$HOME/micromamba"
    __mamba_setup="$($MAMBA_EXE shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
    if (( $? == 0 )); then
        eval "$__mamba_setup"
    else
        alias micromamba="$MAMBA_EXE"
    fi
    alias mamba='micromamba'
    alias conda='micromamba'
    unset __mamba_setup
elif [[ -x "$HOME/conda/bin/conda" ]]; then
    __conda_setup="$("$HOME/conda/bin/conda" shell.zsh hook 2>/dev/null)"
    if (( $? == 0 )); then
        eval "$__conda_setup"
    elif [[ -r "$HOME/conda/etc/profile.d/conda.sh" ]]; then
        source "$HOME/conda/etc/profile.d/conda.sh"
    fi
    unset __conda_setup
fi

# -----------------------------------------------
# JavaScript

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
alias npmreset='rm -rf node_modules'

export ASTRO_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DEBUG=1
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

# -----------------------------------------------
# Compilers and language toolchains

if [[ $OSTYPE == darwin* && -n ${HOMEBREW_PREFIX:-} ]]; then
    if [[ -d "$HOMEBREW_PREFIX/opt/llvm" ]]; then
        export LDFLAGS="-L$HOMEBREW_PREFIX/opt/llvm/lib${LDFLAGS:+ $LDFLAGS}"
        export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/llvm/include${CPPFLAGS:+ $CPPFLAGS}"
    fi
    prepend_path "$HOMEBREW_PREFIX/opt/openjdk/bin"
fi

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
prepend_path "$GOBIN"
export GO111MODULE=on

goinstalltools() {
    go install github.com/incu6us/goimports-reviser/v3@latest
    go install github.com/segmentio/golines@latest
}

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
