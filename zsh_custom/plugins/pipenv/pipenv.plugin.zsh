# pyenv
# eval "$(pyenv init -)"

# Homebrew links
export PATH=/usr/local/opt/python/libexec/bin:$PATH

# pyenv
# export PYENV_ROOT=$(pyenv root)                  # Slow
# export PATH=$(pyenv root)/shims:$PATH            # Slow
export PYENV_ROOT=/Users/drodriguez/.pyenv         # Fast 
export PATH=/Users/drodriguez/.pyenv/shims:$PATH   # Fast

# Make pipenv use pyenv activated python
export PIPENV_PYTHON=$PYENV_ROOT/shims/python

# Disable default VENV PS1
export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_prompt_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        # venv="${VIRTUAL_ENV##*/}"  ## Only works if envname is the final part of the path
        venv="$(echo $VIRTUAL_ENV | cut -d'/' -f7)"
        # echo $venv
    else
        # In case you don't have one activated
        venv=''
    fi

    echo "(%{$fg[yellow]%}py%{$reset_color%}:$venv)"
}

# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1
