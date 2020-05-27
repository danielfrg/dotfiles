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
