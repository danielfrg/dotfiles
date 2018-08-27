
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
# PROMPT=$'%{$fg[cyan]%}%~%{$reset_color%} $(conda_prompt_info) $(kube_ps1) $(git_prompt_info)\n${ret_status} %{$reset_color%}'

# # Empty line after output
# function echo_blank() {
#   echo
# }
# # preexec_functions+=echo_blank  # Empty line before output? why? dont know...
# precmd_functions+=echo_blank


#########################
# POWERLINE-GO
#########################

function powerline_precmd() {
    PS1="$(/usr/local/bin/powerline-go -shell zsh -modules cwd,venv,kube,git,exit -error $? -newline -shorten-gke-names)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

#########################

# Color scheme
BASE16_SHELL="$HOME/workspace/dotfiles/iterm2/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export PATH=/usr/local/sbin:$PATH
# export PATH=$(brew --prefix coreutils)/libexec/bin:$PATH    # Slow
export PATH=/usr/local/opt/coreutils/libexec/bin:$PATH        # Fast
# export PATH=$(brew --prefix moreutils)/libexec/gnubin:$PATH    # Slow
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH        # Fast

bindkey '[C' forward-word
bindkey '[D' backward-word
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word

## For some stuff that want at startup but not commited
source ~/.zshrc.local
