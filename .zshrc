# Path to your oh-my-zsh installation.
export ZSH=/Users/drodriguez/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"
# DISABLE_AUTO_UPDATE=true

ZSH_CUSTOM=~/workspace/dotfiles/zsh_custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(osx base aliases z fzf git imgcat golang2 java conda docker2 k8s cloud rsync2)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

#########################
# PROMPT
# Has to be done after sourcing oh-my-zsh
#########################

# Looks like: danielfrg at host in ~ (with some spaces)
# Blue user: %{$fg[blue]%}%n%{$reset_color%}
# Green host: %{$fg[green]%}%m%{$reset_color%}
# Blue location: %{$fg[cyan]%}%c%{$reset_color%}
# PROMPT=$'%{$fg[blue]%}%n%{$reset_color%} at %{$fg[green]%}%m%{$reset_color%} in %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)\n${ret_status} %{$reset_color%}'

# Looks like: ~ (conda:base) (kube:context) git:(master) X
# Blue location: %{$fg[cyan]%}%c%{$reset_color%}
PROMPT=$'%{$fg[cyan]%}%~%{$reset_color%} $(conda_prompt_info) $(kube_ps1) $(git_prompt_info)\n${ret_status} %{$reset_color%}'

# Empty line after output
function echo_blank() {
  echo
}
# preexec_functions+=echo_blank  # Empty line before output? why? dont know...
precmd_functions+=echo_blank
