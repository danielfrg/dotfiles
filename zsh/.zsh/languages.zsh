# PYTHON
# ==========

export HATCH_CONFIG=$HOME/.config/hatch/config.toml

# Rye config
# export PATH="$HOME/.rye/shims:$PATH"

# Activate conda
useconda() {
    # Remove RYE
    PATH=$(echo "$PATH" | sed -e 's@:/Users/danrodriguez/.rye/shims@@g')

    eval "$(/Users/danrodriguez/conda/bin/conda shell.zsh hook)"
}

# Activate pyenv
# usepyenv() {
#     # Remove RYE
#     PATH=$(echo "$PATH" | sed -e 's@:/Users/danrodriguez/.rye/shims@@g')
#
#     export PYENV_ROOT="$HOME/.pyenv"
#     export PATH="$PYENV_ROOT/bin:$PATH"
#     export PYENV_VIRTUALENV_DISABLE_PROMPT=1
#
#     # Copy/Paste directly this to make it faster
#     # Default to evaluate if not in MacOS
#     if [[ $(uname) == "Darwin" ]]; then
#         # Start: pyenv init - --no-rehash zsh
#         PATH="$(bash --norc -ec 'IFS=:; paths=($PATH);
#         for i in ${!paths[@]}; do
#         if [[ ${paths[i]} == "''/Users/danrodriguez/.pyenv/shims''" ]]; then unset '\''paths[i]'\'';
#         fi; done;
#         echo "${paths[*]}"')"
#         export PATH="/Users/danrodriguez/.pyenv/shims:${PATH}"
#         export PYENV_SHELL=zsh
#         source '/opt/homebrew/Cellar/pyenv/2.3.30/libexec/../completions/pyenv.zsh'
#         pyenv() {
#         local command
#         command="${1:-}"
#         if [ "$#" -gt 0 ]; then
#             shift
#         fi
#
#         case "$command" in
#         activate|deactivate|rehash|shell)
#             eval "$(pyenv "sh-$command" "$@")"
#             ;;
#         *)
#             command pyenv "$command" "$@"
#             ;;
#         esac
#         }
#         # End: pyenv init
#
#         # Start: pyenv virtualenv-init - --no-rehash zsh
#         export PATH="/opt/homebrew/Cellar/pyenv-virtualenv/1.2.1/shims:${PATH}";
#         export PYENV_VIRTUALENV_INIT=1;
#         _pyenv_virtualenv_hook() {
#         local ret=$?
#         if [ -n "${VIRTUAL_ENV-}" ]; then
#             eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
#         else
#             eval "$(pyenv sh-activate --quiet || true)" || true
#         fi
#         return $ret
#         };
#         # End: pyenv virtualenv-init
#     else
#         if type pyenv > /dev/null; then
#             eval "$(pyenv init - --no-rehash zsh)"
#             eval "$(pyenv virtualenv-init - --no-rehash zsh)"
#         fi
#     fi
# }

function pyclean() {
    find_ . -type f -name '*.py[co]' -delete
    find_ . -type d -name __pycache__ -exec rm -rf {} +
    find_ . -type d -name dist -exec rm -rf {} +
    find_ . -type d -name .ipynb_checkpoints -exec rm -rf {} +
    find_ . -type d -name .pytest_cache -exec rm -rf {} +
    find_ . -type d -name .venv -exec rm -rf {} +
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# JS
# ==========

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

alias npmreset="rm -rf node_modules"

alias npm_="/Users/danrodriguez/.volta/bin/npm"
alias npm=pnpm
alias npx=pnpx

export NEXT_TELEMETRY_DEBUG=1.
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

# pnpm
export PNPM_HOME="/Users/danrodriguez/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

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

# source $HOME/.cargo/env

# JAVA
# ==========

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Kubernetes
# ==========

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

# DOCKER
# ==========

docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() { docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
docker-rmi-prefix () { docker rmi -f $(docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}') }
docker-rmi-all () { docker rmi -f $(docker images --format '{{.ID}}') }
