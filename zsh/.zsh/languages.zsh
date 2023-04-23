# PYTHON -----------------------------------------------------------------------

export PATH="$HOME/.rye/shims:$PATH"
export HATCH_CONFIG=$HOME/.config/hatch/config.toml

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Copy/Paste directly this to make it faster
# Default to evaluate if not in MacOS
# if [[ $(uname) == "Darwin" ]]; then
#     # Start: pyenv init - --no-rehash zsh
#     PATH="$(bash --norc -ec 'IFS=:; paths=($PATH);
#     for i in ${!paths[@]}; do
#     if [[ ${paths[i]} == "''/Users/danielfrg/.pyenv/shims''" ]]; then unset '\''paths[i]'\'';
#     fi; done;
#     echo "${paths[*]}"')"
#     export PATH="/Users/danielfrg/.pyenv/shims:${PATH}"
#     export PYENV_SHELL=zsh
#     source '/opt/homebrew/Cellar/pyenv/2.3.17/libexec/../completions/pyenv.zsh'
#     pyenv() {
#     local command
#     command="${1:-}"
#     if [ "$#" -gt 0 ]; then
#         shift
#     fi

#     case "$command" in
#     activate|deactivate|rehash|shell)
#         eval "$(pyenv "sh-$command" "$@")"
#         ;;
#     *)
#         command pyenv "$command" "$@"
#         ;;
#     esac
#     }
#     # End: pyenv init

#     # Start: pyenv virtualenv-init - --no-rehash zsh
#     export PATH="/opt/homebrew/Cellar/pyenv-virtualenv/1.2.1/shims:${PATH}";
#     export PYENV_VIRTUALENV_INIT=1;
#     _pyenv_virtualenv_hook() {
#     local ret=$?
#     if [ -n "${VIRTUAL_ENV-}" ]; then
#         eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
#     else
#         eval "$(pyenv sh-activate --quiet || true)" || true
#     fi
#     return $ret
#     };
#     # End: pyenv virtualenv-init
# else
#     if type pyenv > /dev/null; then
#         eval "$(pyenv init - --no-rehash zsh)"
#         eval "$(pyenv virtualenv-init - --no-rehash zsh)"
#     fi
# fi

function pyclean() {
    find . -type f -name '*.py[co]' -delete
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name .ipynb_checkpoints -exec rm -rf {} +
	find . -type d -name .pytest_cache -exec rm -rf {} +
}

# JS ---------------------------------------------------------------------------

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

alias npmreset="rm -rf node_modules"

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
    if type rbenv > /dev/null; then
        eval "$(rbenv init - --no-rehash zsh)"
    fi
fi
