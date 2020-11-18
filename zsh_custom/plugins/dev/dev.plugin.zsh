# PYTHON -----------------------------------------------------------------------

# For Jupyter and Voila bug
ulimit -n 4096

.  ~/conda/etc/profile.d/conda.sh
conda activate base

alias activatethis='source $PWD/.venv/bin/activate'
alias workhere='source $PWD/.venv/bin/activate'

# Autocomplete
fpath+=$PWD
compinit conda

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

# function conda_prompt_info() {
#     echo "(%{$fg[yellow]%}py%{$reset_color%}:$CONDA_DEFAULT_ENV)"
# }

# conda_root_dir() {
#     # This works but its slow so just hard coded :)
#     # ANACONDA=$(conda info | grep root | awk 'BEGIN { FS = " " } ; { print $4 }' | sed 's/^[ \t]*//;s/[ \t]*$//')
#     ANACONDA="$HOME/workspace/conda"
# }

# lsvirtualenvs() {
#     conda_root_dir
#     ls $ANACONDA/envs
# }

# _complete_conda_envs() {
#     conda_root_dir
#     compadd $(ls $ANACONDA/envs)
# }

# rmvirtualenv() {
#     conda_root_dir
#     rm -rf $ANACONDA/envs/$1
# }
# compdef _complete_conda_envs rmvirtualenv

# cdvirtualenv() {
#     conda_root_dir
#     cd $ANACONDA/envs/$1
# }
# compdef _complete_conda_envs cdvirtualenv

# workon() {
#     conda_root_dir
#     source $ANACONDA/bin/activate $1
# }
# compdef _complete_conda_envs workon

# workoff() {
#     conda_root_dir
#     source $ANACONDA/bin/deactivate
# }

# GO ---------------------------------------------------------------------------

# local tools_dir=~/go
# export PATH=$tools_dir/bin:$PATH

# export GOPATH=~/go
# export PATH=$GOPATH/bin:$PATH

# gopathhere() {
#     export GOPATH=$(pwd)
#     export PATH=$GOPATH/bin:$PATH
#     export GOBIN=$(pwd)/bin
#     echo GOPATH=$GOPATH
#     echo PATH=$PATH
#     echo GOBIN=$GOBIN
# }

# goinstalltools() {
#     # local old_path=$PATH
#     # local old_go_path=$GOPATH
#     # export GOPATH=$tools_dir
#     go get -v -u golang.org/x/lint/golint
#     go get -v -u github.com/derekparker/delve/cmd/dlv
#     go get -v -u github.com/uudashr/gopkgs/cmd/gopkgs
#     go get -v -u github.com/nsf/gocode
#     go get -v -u github.com/rogpeppe/godef
#     go get -v -u golang.org/x/tools/cmd/goimports
#     go get -v -u github.com/ramya-rao-a/go-outline
#     go get -u -v github.com/mdempsky/gocode
#     # export PATH=$old_path
#     # export GOPATH=$old_go_path
# }


# JS ---------------------------------------------------------------------------

alias npmreset="rm -rf node_modules && npm i"
# alias npmreset="rm -rf node_modules && nvm use && npm i"


# JAVA -------------------------------------------------------------------------

export JAVA_HOME=`/usr/libexec/java_home`
export JRE_HOME=`/usr/libexec/java_home`
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
# export JRE_HOME=`/usr/libexec/java_home -v 1.8`


# DOCKER -----------------------------------------------------------------------

docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() {docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
docker-rmi-prefix () { docker rmi -f $(docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}') }
