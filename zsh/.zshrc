# Based on https://github.com/getantidote/zdotdir

# Zsh options
setopt extended_glob

# Set the directory we want to store antidote
ANTIDOTE_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/antidote"

# Download antidote, if it's not there yet
if [ ! -d "$ANTIDOTE_HOME" ]; then
   mkdir -p "$(dirnam¬e $ANTIDOTE_HOME)"
   git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
fi

export ZSH_CUSTOM="${HOME}/.zsh"

# load antidote
source "${ANTIDOTE_HOME}/antidote.zsh"
antidote load

source "${ZSH_CUSTOM}/base.zsh"
source "${ZSH_CUSTOM}/prompt.zsh"
source "${HOME}/code/dotfiles/personal/entrypoint.sh"

# Completion stuff
autoload -Uz compinit
compinit

# ---------------------------------
# Stuff that is not to be committed

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
