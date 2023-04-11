# PYTHON -----------------------------------------------------------------------

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# eval "$(pyenv init --path)"

eval "$(pyenv init - --no-rehash zsh)"
eval "$(pyenv virtualenv-init - --no-rehash zsh)"

alias activatethis='source $PWD/.venv/bin/activate'
alias workhere='source $PWD/.venv/bin/activate'

export HATCH_CONFIG=$HOME/.config/hatch/config.toml

# .  ~/mambaforge/etc/profile.d/conda.sh
# conda activate base

# # Conda autocomplete
# fpath+=$PWD
# compinit conda

# Auto activate conda envs
# thisdir=${0:a:h}
# source $thisdir/conda_auto_env.sh
# autoload -U add-zsh-hook
# add-zsh-hook chpwd conda_auto_env

function pyclean() {
  find . -type f -name '*.py[co]' -delete
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name .ipynb_checkpoints -exec rm -rf {} +
	find . -type d -name .pytest_cache -exec rm -rf {} +
}

# JS ---------------------------------------------------------------------------

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

alias npmreset="rm -rf node_modules && npm i"
# alias npmreset="rm -rf node_modules && nvm use && npm i"

# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

# JAVA -------------------------------------------------------------------------

# export JAVA_HOME=`/usr/libexec/java_home`
# export JRE_HOME=`/usr/libexec/java_home`
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
# export JRE_HOME=`/usr/libexec/java_home -v 1.8`

# RUBY -------------------------------------------------------------------------

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
 eval "$(rbenv init - zsh)"

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
