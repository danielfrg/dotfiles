# PYTHON -----------------------------------------------------------------------

export HATCH_CONFIG=$HOME/.config/hatch/config.toml

# Rye config
export PATH="$HOME/.rye/shims:$PATH"

# Activate pyenv
usepyenv() {
    # Remove RYE
    PATH=$(echo "$PATH" | sed -e 's@:/Users/danielfrg/.rye/shims@@g')

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
        source '/opt/homebrew/Cellar/pyenv/2.3.30/libexec/../completions/pyenv.zsh'
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
        if type pyenv > /dev/null; then
            eval "$(pyenv init - --no-rehash zsh)"
            eval "$(pyenv virtualenv-init - --no-rehash zsh)"
        fi
    fi
}

function pyclean() {
    find_ . -type f -name '*.py[co]' -delete
	find_ . -type d -name __pycache__ -exec rm -rf {} +
    find_ . -type d -name dist -exec rm -rf {} +
	find_ . -type d -name .ipynb_checkpoints -exec rm -rf {} +
	find_ . -type d -name .pytest_cache -exec rm -rf {} +
    # find_ . -type d -name .venv -exec rm -rf {} +
}

function virtualenv_prompt_info() {
  [[ -n ${VIRTUAL_ENV} ]] || return
  local NAME="${VIRTUAL_ENV:t}"
  if [[ $NAME == "venv" || $NAME == "env" || $NAME == ".venv" ]]; then
    local BASE="${VIRTUAL_ENV:h}"
    NAME="${BASE:t}"
  fi
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${NAME}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# JS ---------------------------------------------------------------------------

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

alias npmreset="rm -rf node_modules"

alias npm_="/Users/danielfrg/.volta/bin/npm"
alias npm=pnpm
alias npx=pnpx

export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1


# pnpm
export PNPM_HOME="/Users/danielfrg/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

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
    go install -v github.com/incu6us/goimports-reviser/v3@latest
    go install github.com/segmentio/golines@latest
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
