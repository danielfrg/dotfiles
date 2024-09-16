# PYTHON
# ------

export PATH=$HOME/.pixi/bin:$PATH

export HATCH_CONFIG=$HOME/.config/hatch/config.toml

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

# JS
# ==========

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

alias npmreset="rm -rf node_modules"

alias npm_="$HOME/.volta/bin/npm"
alias npm=pnpm
# alias npx=pnpm dlx

export ASTRO_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DEBUG=1.
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

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

# C/C++
# ==========

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# GO
# ==========

export GOPATH=~/go
export GOBIN=~/go/bin
export PATH=$GOPATH/bin:$PATH
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

# RUST
# ==========

if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

# JAVA
# ==========

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Kubernetes
# ==========

if type kubectl >/dev/null 2>&1; then
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi
fi

k() {
  if [[ "$1" == "get" ]]; then
    kubectl get --sort-by=.metadata.name "${@:2}"
  else
    kubectl "$@"
  fi
}

compdef k='kubectl'

alias klogs="kubectl logs"
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

# DOCKER
# ==========

docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() { docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
docker-rmi-prefix () { docker rmi -f $(docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}') }
docker-rmi-all () { docker rmi -f $(docker images --format '{{.ID}}') }
