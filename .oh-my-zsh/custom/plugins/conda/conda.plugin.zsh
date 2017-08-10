export PATH=$HOME/anaconda/bin:$PATH

# This is slow to create a new terminal? :S
# mydir=${0:a:h}
# source $mydir/conda_auto_env.sh
# autoload -U add-zsh-hook
# add-zsh-hook chpwd conda_auto_env

fpath+=$PWD
compinit conda

conda_root_dir() {
    # This works but its slow, just hard coded :)
    # ANACONDA=$(conda info | grep root | awk 'BEGIN { FS = " " } ; { print $4 }' | sed 's/^[ \t]*//;s/[ \t]*$//')
    ANACONDA="$HOME/anaconda"
}

lsvirtualenvs() {
    conda_root_dir
    ls $ANACONDA/envs
}

_complete_conda_envs() {
    conda_root_dir
    compadd $(ls $ANACONDA/envs)
}

rmvirtualenv() {
    conda_root_dir
    rm -rf $ANACONDA/envs/$1
}
compdef _complete_conda_envs rmvirtualenv

cdvirtualenv() {
    conda_root_dir
    cd $ANACONDA/envs/$1
}
compdef _complete_conda_envs cdvirtualenv

workon() {
    conda_root_dir
    source $ANACONDA/bin/activate $1
}
compdef _complete_conda_envs workon

workoff() {
    conda_root_dir
    source $ANACONDA/bin/deactivate
}
