# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Local binaries
export PATH=$HOME/.local/bin:$HOME/.local/scripts:$PATH

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE=true

ZSH_CUSTOM=$HOME/code/dotfiles/zsh_custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# plugins=(base dev poetry fzf imgcat z zsh-autosuggestions)
plugins=(base languages fzf z zsh-autosuggestions zsh-syntax-highlighting)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

#########################
# REGULAR PROMPT (not powerline10k)
# Has to be done just after sourcing oh-my-zsh in ~/.zshrc
#########################

# Looks like: danielfrg at host in ~ (with some spaces)
# Blue user: %{$fg[blue]%}%n%{$reset_color%}
# Green host: %{$fg[green]%}%m%{$reset_color%}
# Blue location: %{$fg[cyan]%}%c%{$reset_color%}
# PROMPT=$'%{$fg[blue]%}%n%{$reset_color%} at %{$fg[green]%}%m%{$reset_color%} in %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)\n${ret_status} %{$reset_color%}'
