# DOCKER -----------------------------------------------------------------------

docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() { docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
docker-rmi-prefix () { docker rmi -f $(docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}') }

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

# RUST

export PATH=$HOME/.cargo/bin:$PATH

# JS ---------------------------------------------------------------------------

alias npmreset="rm -rf node_modules && npm i"
# alias npmreset="rm -rf node_modules && nvm use && npm i"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# RUBY -------------------------------------------------------------------------

export PATH="/usr/local/opt/ruby@2.7/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

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

# JAVA -------------------------------------------------------------------------

export JAVA_HOME=`/usr/libexec/java_home`
export JRE_HOME=`/usr/libexec/java_home`
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
# export JRE_HOME=`/usr/libexec/java_home -v 1.8`

