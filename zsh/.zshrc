# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH Options
DISABLE_AUTO_UPDATE=true
ZSH_CUSTOM=$HOME/code/dotfiles/zsh_custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(base languages fzf z zsh-autosuggestions zsh-syntax-highlighting imgcat)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
