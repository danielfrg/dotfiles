# Zsh options
setopt extended_glob

# Set the directory we want to store antidote
ANTIDOTE_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/antidote"

# Download antidote, if it's not there yet
if [ ! -d "$ANTIDOTE_HOME" ]; then
   mkdir -p "$(dirname $ANTIDOTE_HOME)"
   git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
fi

# Autoload functions you might want to use with antidote.
# Not needed i think
# ZFUNCDIR=${ZFUNCDIR:-$HOME/.zsh/functions}
# fpath=($ZFUNCDIR $fpath)
# autoload -Uz $fpath[1]/*(.:t)

export ZSH_CUSTOM="${HOME}/.zsh"

# load antidote
source "${ANTIDOTE_HOME}/antidote.zsh"
antidote load

source "${ZSH_CUSTOM}/base.zsh"
source "${ZSH_CUSTOM}/prompt.zsh"

# # Add in snippets
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
# zinit snippet OMZP::command-not-found

# zinit cdreplay -q

# # My config
# for file in "${HOME}/.zsh/base.zsh" \
#             "${HOME}/code/dotfiles/personal/entrypoint.sh" \
#             "${HOME}/.zsh/prompt.zsh"
# do
#     [ -s "${file}" ] && source "${file}"
# done

# zi ice pick"async.zsh" src"${HOME}/.zsh/dev.zsh"

# ---------------------------------
# Stuff that is not to be committed

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
