# PYTHON -----------------------------------------------------------------------

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Copy/Paste directly this to make it faster
# Default to evaluate if not in MacOS
if [[ $(uname) == "Darwin" ]]; then
    # Start: pyenv init - --no-rehash zsh
    PATH="$(bash --norc -ec 'IFS=:; paths=($PATH);
    for i in ${!paths[@]}; do
    if [[ ${paths[i]} == "''/Users/danielfrg/.pyenv/shims''" ]]; then unset '\''paths[i]'\'';
    fi; done;
    echo "${paths[*]}"')"
    export PATH="/Users/danielfrg/.pyenv/shims:${PATH}"
    export PYENV_SHELL=zsh
    source '/opt/homebrew/Cellar/pyenv/2.3.17/libexec/../completions/pyenv.zsh'
    pyenv() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
        shift
    fi

    case "$command" in
    activate|deactivate|rehash|shell)
        eval "$(pyenv "sh-$command" "$@")"
        ;;
    *)
        command pyenv "$command" "$@"
        ;;
    esac
    }
    # End: pyenv init

    # Start: pyenv virtualenv-init - --no-rehash zsh
    export PATH="/opt/homebrew/Cellar/pyenv-virtualenv/1.2.1/shims:${PATH}";
    export PYENV_VIRTUALENV_INIT=1;
    _pyenv_virtualenv_hook() {
    local ret=$?
    if [ -n "${VIRTUAL_ENV-}" ]; then
        eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
    else
        eval "$(pyenv sh-activate --quiet || true)" || true
    fi
    return $ret
    };
    # End: pyenv virtualenv-init
else
    eval "$(pyenv init - --no-rehash zsh)"
    eval "$(pyenv virtualenv-init - --no-rehash zsh)"
fi


export HATCH_CONFIG=$HOME/.config/hatch/config.toml

function pyclean() {
  find . -type f -name '*.py[co]' -delete
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name .ipynb_checkpoints -exec rm -rf {} +
	find . -type d -name .pytest_cache -exec rm -rf {} +
}

# # JS ---------------------------------------------------------------------------

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

alias npmreset="rm -rf node_modules"

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

# GO ---------------------------------------------------------------------------

export GOPATH=~/go
export GOBIN=~/go/bin
export PATH=$GOPATH/bin:$PATH
export GO111MODULE=on

goinstalltools() {
    # local old_path=$PATH
    # local old_go_path=$GOPATH
    # export GOPATH=$tools_dir
    go get -v -u golang.org/x/lint/golint
    go get -v -u github.com/derekparker/delve/cmd/dlv
    go get -v -u github.com/uudashr/gopkgs/cmd/gopkgs
    go get -v -u github.com/nsf/gocode
    go get -v -u github.com/rogpeppe/godef
    go get -v -u golang.org/x/tools/cmd/goimports
    go get -v -u github.com/ramya-rao-a/go-outline
    go get -u -v github.com/mdempsky/gocode
    # export PATH=$old_path
    # export GOPATH=$old_go_path
}

# RUST -------------------------------------------------------------------------

# source $HOME/.cargo/env

# RUBY -------------------------------------------------------------------------

# Add RVM to PATH

# Copy/Paste directly this to make it faster
# Default to evaluate if not in MacOS
if [[ $(uname) == "Darwin" ]]; then
    # Start: rbenv init - --no-rehash zsh
    export PATH="/Users/danielfrg/.rbenv/shims:${PATH}"
    export RBENV_SHELL=zsh
    source '/opt/homebrew/Cellar/rbenv/1.2.0/libexec/../completions/rbenv.zsh'
    rbenv() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
        shift
    fi

    case "$command" in
    rehash|shell)
        eval "$(rbenv "sh-$command" "$@")";;
    *)
        command rbenv "$command" "$@";;
    esac
    }
    # End: rbenv init
else
    eval "$(rbenv init - --no-rehash zsh)"
fi

# JAVA -------------------------------------------------------------------------

# export JAVA_HOME=`/usr/libexec/java_home`
# export JRE_HOME=`/usr/libexec/java_home`
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
# export JRE_HOME=`/usr/libexec/java_home -v 1.8`

# AWS --------------------------------------------------------------------------

# AWS Credentials as ENV VARs

# function read_aws_credentials_key {
#   FILE=~/.aws/credentials
#   if [ -f $FILE ]; then
#     section=$1
#     key=$2
#     awk -F ' *= *' '{ if ($1 ~ /^\[/) section=$1; else if ($1 !~ /^$/) print $1 section "=" $2 }' $FILE | grep "$2\[$1\]" | sed 's/.*=//'
#   fi
# }

# function read_aws_credentials_key {
#   FILE=~/.aws/credentials
#   if [ -f $FILE ]; then
#     section=$1
#     key=$2
#     awk -F ' *= *' '{ if ($1 ~ /^\[/) section=$1; else if ($1 !~ /^$/) print $1 section "=" $2 }' $FILE | grep "$2\[$1\]" | sed 's/.*=//'
#   fi
# }

# export AWS_ACCESS_KEY_ID=$(read_aws_credentials_key default aws_access_key_id)
# export AWS_SECRET_ACCESS_KEY=$(read_aws_credentials_key default aws_secret_access_key)
# export AWS_DEFAULT_REGION=$(read_aws_credentials_key default region)

# export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
# export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
# export TF_VAR_AWS_REGION=$AWS_DEFAULT_REGION

# alias ec2pubips="aws ec2 describe-instances --query 'Reservations[*].Instances[*].{A_PUB:PublicIpAddress, B_PRIV:NetworkInterfaces[0].PrivateDnsName}' --output text"
